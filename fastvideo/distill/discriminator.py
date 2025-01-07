from typing import Any, Dict, Optional, Union

import torch
import torch.nn as nn

from diffusers.configuration_utils import ConfigMixin, register_to_config
from diffusers.loaders import FromOriginalModelMixin, PeftAdapterMixin
from diffusers.models.attention import JointTransformerBlock
from diffusers.models.attention_processor import Attention, AttentionProcessor
from diffusers.models.modeling_utils import ModelMixin
from diffusers.models.normalization import AdaLayerNormContinuous
from diffusers.utils import (
    USE_PEFT_BACKEND,
    is_torch_version,
    logging,
    scale_lora_layers,
    unscale_lora_layers,
)
from diffusers.models.embeddings import CombinedTimestepTextProjEmbeddings, PatchEmbed
from diffusers.models.transformers.transformer_2d import Transformer2DModelOutput
from diffusers.models.transformers.transformer_sd3 import SD3Transformer2DModel

logger = logging.get_logger(__name__)  # pylint: disable=invalid-name


class DiscriminatorHead(nn.Module):
    def __init__(self, input_channel, output_channel=1, args=None):
        super().__init__()
        inner_channel = 1024
        self.conv1 = nn.Sequential(
            nn.Conv2d(input_channel, inner_channel, 1, 1, 0),
            nn.GroupNorm(32, inner_channel),
            nn.LeakyReLU(
                inplace=True
            ),  # use LeakyReLu instead of GELU shown in the paper to save memory
        )
        self.conv2 = nn.Sequential(
            nn.Conv2d(inner_channel, inner_channel, 1, 1, 0),
            nn.GroupNorm(32, inner_channel),
            nn.LeakyReLU(
                inplace=True
            ),  # use LeakyReLu instead of GELU shown in the paper to save memory
        )

        self.conv_out = nn.Conv2d(inner_channel, output_channel, 1, 1, 0)
        
        vae_spatial_scale_factor = 8
        
        self.patch_height = args.num_height // vae_spatial_scale_factor // 2
        self.patch_width = args.num_width // vae_spatial_scale_factor // 2
        print("## DiscriminatorHead: patch_height: ", self.patch_height)
        print("## DiscriminatorHead: patch_width: ", self.patch_width)

    def forward(self, x):
        b, twh, c = x.shape
        
        t = twh // (self.patch_height * self.patch_width)
        x = x.view(-1, self.patch_height * self.patch_width, c)
        x = x.permute(0, 2, 1)
        x = x.view(b * t, c, self.patch_height, self.patch_width)
        x = self.conv1(x)
        x = self.conv2(x) + x
        x = self.conv_out(x)
        return x


class Discriminator(nn.Module):
    def __init__(
        self,
        stride=8,
        num_h_per_head=1,
        adapter_channel_dims=[3072],
        total_layers = 48,
        args=None,
    ):
        super().__init__()
        adapter_channel_dims = adapter_channel_dims * (total_layers // stride)
        self.stride = stride
        self.num_h_per_head = num_h_per_head
        self.head_num = len(adapter_channel_dims)
        self.heads = nn.ModuleList(
            [
                nn.ModuleList(
                    [
                        DiscriminatorHead(
                            adapter_channel, 
                            args=args
                        )
                        for _ in range(self.num_h_per_head)
                    ]
                )
                for adapter_channel in adapter_channel_dims
            ]
        )

    def forward(self, features):
        outputs = []

        def create_custom_forward(module):
            def custom_forward(*inputs):
                return module(*inputs)

            return custom_forward

        assert len(features) == len(self.heads)
        for i in range(0, len(features)):
            for h in self.heads[i]:
                # out = torch.utils.checkpoint.checkpoint(
                #     create_custom_forward(h),
                #     features[i],
                #     use_reentrant=False
                # )
                out = h(features[i])
                outputs.append(out)
        return outputs


class DMDiscriminator(nn.Module):
    
    def __init__(self):
        super().__init__()
    
        self.cls_pred_branch = nn.Sequential(
            nn.Conv2d(kernel_size=4, in_channels=1280, out_channels=1280, stride=2, padding=1), # 8x8 -> 4x4 
            nn.GroupNorm(num_groups=32, num_channels=1280),
            nn.SiLU(),
            nn.Conv2d(kernel_size=4, in_channels=1280, out_channels=1280, stride=4, padding=0), # 4x4 -> 1x1
            nn.GroupNorm(num_groups=32, num_channels=1280),
            nn.SiLU(),
            nn.Conv2d(kernel_size=1, in_channels=1280, out_channels=1, stride=1, padding=0), # 1x1 -> 1x1
        )

        self.cls_pred_branch.requires_grad_(True)
        
    def forward(self, features):
        print("## features shape: ", features.shape)
        return self.cls_pred_branch(features)
