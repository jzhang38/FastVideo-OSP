export WANDB_BASE_URL="https://api.wandb.ai"
export WANDB_MODE=online
torchrun --nnodes 1 --nproc_per_node 4 --master_port 29903 \
    fastvideo/train.py \
    --seed 1024 \
    --pretrained_model_name_or_path data/hunyuan_diffusers \
    --model_type hunyuan_hf \
    --cache_dir data/.cache \
    --data_json_path data/Image-Vid-Finetune-Src/videos2caption.json \
    --validation_prompt_dir data/Image-Vid-Finetune-Src/validation \
    --gradient_checkpointing \
    --train_batch_size 1 \
    --num_latent_t 24 \
    --sp_size 4 \
    --train_sp_batch_size 1 \
    --dataloader_num_workers 4 \
    --gradient_accumulation_steps 4 \
    --max_train_steps 2000 \
    --learning_rate 8e-5 \
    --mixed_precision bf16 \
    --checkpointing_steps 500 \
    --validation_steps 100 \
    --validation_sampling_steps 50 \
    --checkpoints_total_limit 3 \
    --allow_tf32 \
    --ema_start_step 0 \
    --cfg 0.0 \
    --ema_decay 0.999 \
    --log_validation \
    --output_dir data/outputs/HSH-Taylor-Finetune-Hunyuan \
    --tracker_project_name HSH-Taylor-Finetune-Hunyuan \
    --num_frames 93 \
    --validation_guidance_scale "1.0" \
    --group_frame \
    --use_lora \
    --lora_rank 32 \
    --lora_alpha 32 \