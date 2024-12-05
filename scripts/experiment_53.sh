export WANDB_BASE_URL="https://api.wandb.ai"
export WANDB_DIR="$HOME"
export WANDB_MODE=online
export WANDB_API_KEY=3913ec5a95a1719c6ea20556959bf22bf910a122
export LD_LIBRARY_PATH=/opt/amazon/efa/lib:/opt/aws-ofi-nccl/lib:$LD_LIBRARY_PATH
export FI_PROVIDER=efa
export FI_EFA_USE_DEVICE_RDMA=1
export NCCL_PROTO=simple

DATA_DIR=/data
IP=10.4.139.86

torchrun --nnodes 2 --nproc_per_node 8\
    --node_rank=0 \
    --rdzv_id=456 \
    --rdzv_backend=c10d \
    --rdzv_endpoint=$IP:29500 \
    fastvideo/distill.py\
    --seed 42\
    --pretrained_model_name_or_path $DATA_DIR/mochi\
    --cache_dir "data/.cache"\
    --data_json_path "$DATA_DIR/Merge-30k-Data/video2caption.json"\
    --validation_prompt_dir "$DATA_DIR/validation_embeddings/validation_prompt_embed_mask"\
    --gradient_checkpointing\
    --train_batch_size=1\
    --num_latent_t 28\
    --sp_size 4\
    --train_sp_batch_size 2\
    --dataloader_num_workers 4\
    --gradient_accumulation_steps=1\
    --max_train_steps=700\
    --learning_rate=1e-6\
    --mixed_precision="bf16"\
    --checkpointing_steps=64\
    --validation_steps 64\
    --validation_sampling_steps "8" \
    --checkpoints_total_limit 3\
    --allow_tf32\
    --ema_start_step 0\
    --cfg 0.0\
    --log_validation\
    --output_dir="$DATA_DIR/outputs/base40_cfg2.0"\
    --tracker_project_name PCM \
    --num_frames  163 \
    --scheduler_type pcm_linear_quadratic \
    --validation_guidance_scale "1.0,1.5,2.5" \
    --num_euler_timesteps 50 \
    --linear_quadratic_threshold 0.1 \
    --linear_range 0.75 \
    --multi_phased_distill_schedule "700-1" \
    --distill_cfg 2.0

torchrun --nnodes 2 --nproc_per_node 8\
    --node_rank=0 \
    --rdzv_id=456 \
    --rdzv_backend=c10d \
    --rdzv_endpoint=$IP:29500 \
    fastvideo/distill.py\
    --seed 42\
    --pretrained_model_name_or_path $DATA_DIR/mochi\
    --cache_dir "data/.cache"\
    --data_json_path "$DATA_DIR/Merge-30k-Data/video2caption.json"\
    --validation_prompt_dir "$DATA_DIR/validation_embeddings/validation_prompt_embed_mask"\
    --gradient_checkpointing\
    --train_batch_size=1\
    --num_latent_t 28\
    --sp_size 4\
    --train_sp_batch_size 2\
    --dataloader_num_workers 4\
    --gradient_accumulation_steps=1\
    --max_train_steps=700\
    --learning_rate=1e-6\
    --mixed_precision="bf16"\
    --checkpointing_steps=64\
    --validation_steps 64\
    --validation_sampling_steps "8" \
    --checkpoints_total_limit 3\
    --allow_tf32\
    --ema_start_step 0\
    --cfg 0.0\
    --log_validation\
    --output_dir="$DATA_DIR/outputs/base40_cfg1.0"\
    --tracker_project_name PCM \
    --num_frames  163 \
    --scheduler_type pcm_linear_quadratic \
    --validation_guidance_scale "0.5,1.5,2.5,3.5" \
    --num_euler_timesteps 50 \
    --linear_quadratic_threshold 0.1 \
    --linear_range 0.75 \
    --multi_phased_distill_schedule "700-1" \
    --distill_cfg 1.0

torchrun --nnodes 2 --nproc_per_node 8\
    --node_rank=0 \
    --rdzv_id=456 \
    --rdzv_backend=c10d \
    --rdzv_endpoint=$IP:29500 \
    fastvideo/distill.py \
    --seed 42\
    --pretrained_model_name_or_path $DATA_DIR/mochi\
    --cache_dir "data/.cache"\
    --data_json_path "$DATA_DIR/Merge-30k-Data/video2caption.json"\
    --validation_prompt_dir "$DATA_DIR/validation_embeddings/validation_prompt_embed_mask"\
    --gradient_checkpointing\
    --train_batch_size=1\
    --num_latent_t 28\
    --sp_size 4\
    --train_sp_batch_size 1 \
    --dataloader_num_workers 4\
    --gradient_accumulation_steps=1\
    --max_train_steps=750\
    --learning_rate=1e-6\
    --mixed_precision="bf16"\
    --checkpointing_steps=64\
    --validation_steps 50 \
    --validation_sampling_steps "8" \
    --checkpoints_total_limit 3\
    --allow_tf32\
    --ema_start_step 0\
    --cfg 0.0\
    --log_validation\
    --output_dir="$DATA_DIR/outputs/lq_euler_50_thres0.1_lrg_phase1_lr1e-6_l2_reconstruct_decay_0.03"\
    --tracker_project_name PCM \
    --num_frames  163 \
    --scheduler_type pcm_linear_quadratic \
    --validation_guidance_scale "0.5,1.5,2.5" \
    --num_euler_timesteps 50 \
    --linear_quadratic_threshold 0.1 \
    --linear_range 0.75 \
    --multi_phased_distill_schedule "750-1" \
    --pred_decay_weight 0.03 \
    --pred_decay_type "reconstruct"