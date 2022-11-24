GPU_IDX=0
NUM_THREADS=96
export OMP_NUM_THREADS=$NUM_THREADS
export CUDA_DEVICE_ORDER="PCI_BUS_ID"
export CUDA_VISIBLE_DEVICES=$GPU_IDX
export OMP_SCHEDULE=STATIC
export OMP_PROC_BIND=CLOSE
export GOMP_CPU_AFFINITY="95-191"

#DATASET_PATH='/home/sitzikbs/Datasets/dfaust/'
DATASET_PATH='/data1/datasets/dfaust/'
MODEL='pn1'
STEPS_PER_UPDATE=5
N_FRAMES=32
BATCH_SIZE=16
TEST_BATCH_SIZE=4

N_POINTS=1024
N_EPOCHS=30
POINTS_SHUFFLE='once'
SAMPLER='weighted'
LOGDIR='./log/'$MODEL'_f'$N_FRAMES'_p'$N_POINTS'_shuffle_'$POINTS_SHUFFLE'_sampler_'$SAMPLER'/'
SET='test'


python3 train_action_pred.py --dataset_path $DATASET_PATH --pc_model $MODEL --steps_per_update $STEPS_PER_UPDATE --frames_per_clip $N_FRAMES --batch_size $BATCH_SIZE --shuffle_points $POINTS_SHUFFLE --logdir $LOGDIR --n_epochs $N_EPOCHS --n_points $N_POINTS --sampler $SAMPLER
python3 test_action_pred.py --dataset_path $DATASET_PATH --pc_model $MODEL --frames_per_clip $N_FRAMES --batch_size $TEST_BATCH_SIZE --shuffle_points $POINTS_SHUFFLE --n_points $N_POINTS --model '000030.pt' --model_path $LOGDIR --set $SET
python3 ./evaluation/evaluate.py --results_path $LOGDIR'results/' --dataset_path $DATASET_PATH --set $SET