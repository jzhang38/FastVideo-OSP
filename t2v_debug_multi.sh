# export WANDB_MODE="offline"

accelerate launch \
    --config_file scripts/accelerate_configs/deepspeed_zero2_config.yaml \
    fastvideo/train.py \
    --cache_dir "data/.cache" \
    --model data/mochi \
    --text_encoder_name google/mt5-base \
    --dataset t2v \
    --data "data/dummyVid/merge_single.txt" \
    --ae CausalVAEModel_D4_4x8x8 \
    --ae_path "data/Open-Sora-Plan-v1.2.0/vae" \
    --sample_rate 1 \
    --num_frames 29 \
    --train_fps 24 \
    --video_length_tolerance_range 200 \
    --max_height 480 \
    --max_width 640 \
    --interpolation_scale_t 1.0 \
    --interpolation_scale_h 1.0 \
    --interpolation_scale_w 1.0 \
    --attention_mode xformers \
    --gradient_checkpointing \
    --train_batch_size=1 \
    --dataloader_num_workers 1 \
    --gradient_accumulation_steps=8 \
    --max_train_steps=1000000 \
    --learning_rate=1e-4 \
    --lr_scheduler="constant" \
    --lr_warmup_steps=0 \
    --mixed_precision="bf16" \
    --report_to="wandb" \
    --checkpointing_steps=250 \
    --allow_tf32 \
    --model_max_length 512 \
    --use_image_num 0 \
    --tile_overlap_factor 0.125 \
    --snr_gamma 5.0 \
    --ema_start_step 0 \
    --cfg 0.1 \
    --noise_offset 0.02 \
    --use_rope \
    --resume_from_checkpoint="latest" \
    --ema_decay 0.999 \
    --enable_tiling \
    --speed_factor 1.0 \
    --sp_size 1 \
    --train_sp_batch_size 1 \
    --output_dir="data/outputs/debug" \