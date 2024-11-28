torchrun --nnodes 1 --nproc_per_node 4 \
    fastvideo/train.py \
    --seed 42 \
    --pretrained_model_name_or_path data/mochi \
    --cache_dir "data/.cache" \
    --data_json_path "data/Encoder_Overfit_Data/videos2caption.json" \
    --validation_prompt_dir "data/Encoder_Overfit_Data/validation_prompt_embed_mask" \
    --uncond_prompt_dir "data/Encoder_Overfit_Data/uncond_prompt_embed_mask" \
    --gradient_checkpointing \
    --train_batch_size 1 \
    --num_latent_t 14 \
    --sp_size 2 \
    --train_sp_batch_size 1 \
    --dataloader_num_workers 1 \
    --gradient_accumulation_steps 2 \
    --max_train_steps 500 \
    --learning_rate 5e-5 \
    --mixed_precision="bf16" \
    --checkpointing_steps 100 \
    --validation_steps 100 \
    --validation_sampling_steps 64 \
    --checkpoints_total_limit 3 \
    --allow_tf32 \
    --ema_start_step 0 \
    --cfg 0.1 \
    --ema_decay 0.999 \
    --log_validation \
    --output_dir data/outputs/BW_Testrun_Test_2 \
    --use_lora \
    --resume_from_lora_checkpoint data/outputs/BW_Testrun_2/lora-checkpoint-100


export WANDB_MODE=online

torchrun --nnodes 1 --nproc_per_node 4 \
    fastvideo/distill.py \
    --seed 42 \
    --pretrained_model_name_or_path data/mochi \
    --cache_dir data/.cache\
    --data_json_path data/Encoder_Overfit_Data/videos2caption.json \
    --validation_prompt_dir data/Encoder_Overfit_Data/validation_prompt_embed_mask \
    --uncond_prompt_dir data/Encoder_Overfit_Data/uncond_prompt_embed_mask \
    --gradient_checkpointing \
    --train_batch_size 1 \
    --num_latent_t 2 \
    --sp_size 2 \
    --train_sp_batch_size 1 \
    --dataloader_num_workers 4 \
    --gradient_accumulation_steps 1 \
    --max_train_steps 20 \
    --learning_rat 1e-6 \
    --mixed_precision bf16 \
    --checkpointing_steps 2 \
    --validation_steps 2 \
    --validation_sampling_steps 8 \
    --checkpoints_total_limit 3 \
    --allow_tf32 \
    --ema_start_step 0 \
    --cfg 0.0 \
    --ema_decay 0.999 \
    --log_validation \
    --tracker_project_name PCM \
    --num_frames 19 \
    --shift 8.0 \
    --validation_guidance_scale 4.5 \
    --output_dir="data/outputs/BW_Testrun_Test" \
    --use_lora \
    --resume_from_lora_checkpoint data/outputs/BW_Testrun_Test/lora-checkpoint-20

    




torchrun --nnodes 1 --nproc_per_node 4\
    fastvideo/distill.py\
    --seed 42\
    --pretrained_model_name_or_path data/mochi\
    --dit_model_name_or_path data/Mochi-Image\
    --cache_dir "data/.cache"\
    --data_json_path "data/Image-Train-Dataset/videos2caption.json"\
    --validation_prompt_dir "data/Encoder_Overfit_Data/validation_prompt_embed_mask"\
    --uncond_prompt_dir "data/Encoder_Overfit_Data/uncond_prompt_embed_mask"\
    --gradient_checkpointing\
    --train_batch_size=8\
    --num_latent_t 1\
    --sp_size 1\
    --train_sp_batch_size 1\
    --dataloader_num_workers 4\
    --gradient_accumulation_steps=1\
    --max_train_steps=20000\
    --learning_rate=1e-6\
    --mixed_precision="bf16"\
    --checkpointing_steps=250\
    --validation_steps 25\
    --validation_sampling_steps 4 \
    --checkpoints_total_limit 3\
    --allow_tf32\
    --ema_start_step 0\
    --cfg 0.0\
    --ema_decay 0.999\
    --log_validation\
    --output_dir="data/outputs/video_distill"\
    --tracker_project_name PCM \
    --num_frames 1 \
    --shift 10.0 \
    --validation_guidance_scale 4.5
    




torchrun --nnodes 1 --nproc_per_node 4 \
    fastvideo/distill.py \
    --seed 42 \
    --pretrained_model_name_or_path data/mochi \
    --cache_dir data/.cache\
    --data_json_path data/Encoder_Overfit_Data/videos2caption.json \
    --validation_prompt_dir data/Encoder_Overfit_Data/validation_prompt_embed_mask \
    --uncond_prompt_dir data/Encoder_Overfit_Data/uncond_prompt_embed_mask \
    --gradient_checkpointing \
    --train_batch_size 1 \
    --num_latent_t 12 \
    --sp_size 4 \
    --train_sp_batch_size 2 \
    --dataloader_num_workers 4 \
    --gradient_accumulation_steps 1 \
    --max_train_steps 20000 \
    --learning_rat 1e-6 \
    --mixed_precision bf16 \
    --checkpointing_steps 50 \
    --validation_steps 25 \
    --validation_sampling_steps 8 \
    --checkpoints_total_limit 3 \
    --allow_tf32 \
    --ema_start_step 0 \
    --cfg 0.0 \
    --ema_decay 0.999 \
    --log_validation \
    --tracker_project_name PCM \
    --output_dir="data/outputs/video_distill"\
    --num_frames 67 \
    --shift 8.0 \
    --validation_guidance_scale 4.5 \
    --use_lora \


















