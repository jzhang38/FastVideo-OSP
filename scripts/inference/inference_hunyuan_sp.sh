#!/bin/bash

num_gpus=4

torchrun --nnodes=1 --nproc_per_node=$num_gpus --master_port 29503 \
    fastvideo/sample/sample_t2v_hunyuan.py \
    --height 720 \
    --width 1280 \
    --num_frames 125 \
    --num_inference_steps 10 \
    --guidance_scale 1 \
    --embedded_cfg_scale 6 \
    --flow_shift 17 \
    --flow-reverse \
    --prompts "A cat walks on the grass, realistic style."\
    --seed 12345 \
    --output_path outputs_video/hunyuan/ 