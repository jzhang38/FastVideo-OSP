# export WANDB_MODE="offline"

export ENTITY="linbin"
export HF_DATASETS_OFFLINE=1 
export TRANSFORMERS_OFFLINE=1
export PDSH_RCMD_TYPE=ssh
# NCCL setting
export GLOO_SOCKET_IFNAME=eth0
export NCCL_SOCKET_IFNAME=eth0
export NCCL_IB_HCA=mlx5_10:1,mlx5_11:1,mlx5_12:1,mlx5_13:1
export NCCL_IB_GID_INDEX=3
export NCCL_IB_TC=162
export NCCL_IB_TIMEOUT=22
export NCCL_PXN_DISABLE=0
export NCCL_IB_QPS_PER_CONNECTION=4
export NCCL_ALGO=Ring
export OMP_NUM_THREADS=1
export MKL_NUM_THREADS=1

accelerate launch \
    --config_file scripts/accelerate_configs/deepspeed_zero2_config.yaml \
    opensora/train/train_t2v_diffusers.py \
    --model OpenSoraT2V-ROPE-L/122 \
    --text_encoder_name google/mt5-xxl \
    --cache_dir "data/.cache" \
    --dataset t2v \
    --data "data/dummyVid/merge.txt" \
    --ae CausalVAEModel_D4_4x8x8 \
    --ae_path "data/Open-Sora-Plan-v1.2.0/vae/" \
    --sample_rate 1 \
    --num_frames 29 \
    --max_height 480 \
    --max_width 640 \
    --pretrained /ephemeral/hao.zhang/codefolder/FastVideo-OSP/data/Open-Sora-Plan-v1.2.0/29x480p/diffusion_pytorch_model.safetensors \
    --interpolation_scale_t 1.0 \
    --interpolation_scale_h 1.0 \
    --interpolation_scale_w 1.0 \
    --attention_mode xformers \
    --gradient_checkpointing \
    --train_batch_size=1 \
    --dataloader_num_workers 10 \
    --gradient_accumulation_steps=8 \
    --max_train_steps=1000000 \
    --learning_rate=1e-4 \
    --lr_scheduler="constant" \
    --lr_warmup_steps=0 \
    --mixed_precision="bf16" \
    --report_to="wandb" \
    --checkpointing_steps=25 \
    --allow_tf32 \
    --model_max_length 512 \
    --use_image_num 0 \
    --tile_overlap_factor 0.125 \
    --snr_gamma 5.0 \
    --use_ema \
    --ema_start_step 0 \
    --cfg 0.1 \
    --noise_offset 0.02 \
    --use_rope \
    --resume_from_checkpoint="latest" \
    --ema_decay 0.999 \
    --enable_tiling \
    --speed_factor 1.0 \
    --group_frame \
    --sp_size 4 \
    --train_sp_batch_size 1 \
    --output_dir="outputs/debug_1node_vid_newpipeline_acc" 