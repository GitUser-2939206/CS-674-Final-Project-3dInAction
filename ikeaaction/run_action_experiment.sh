#!/usr/bin/env bash

GPU_IDX=3
export CUDA_DEVICE_ORDER="PCI_BUS_ID"
export CUDA_VISIBLE_DEVICES=$GPU_IDX

DATASET_PATH='/data1/datasets/ANU_ikea_dataset_smaller/' # on remote
#DATASET_PATH='/home/sitzikbs/Datasets/ANU_ikea_dataset_smaller/' # on local
INPUT_TYPE='pc'
CAMERA='dev3'
#PT_MODEL='charades' # when using images
DB_FILENAME='ikea_annotation_db_full'

#LOGDIR='/home/sitzikbs/Pycharm_projects/3dinaction/log/debug/'
LOGDIR='./log/pn1_4d_1024_baseline/'
BATCH_SIZE=10
STEPS_PER_UPDATE=16
FRAMES_PER_CLIP=32
N_EPOCHS=31
USE_POINTLETTES=0     # deprecated
POINTLET_MODE='none'  # deprecated
N_GAUSSIANS=8         # for 3dmfv

PC_MODEL='pn1_4d'
N_POINTS=1024
CORREFORMER='../correspondance_transformer/log/dfaust_N1024ff1024_d1024h8_ttypenonelr0.0001bs32reg_cat_ce/000200.pt'    # path or 'none'
CACHE_CAPACITY=0

taskset -c 32-64 python train_i3d.py --dataset_path $DATASET_PATH --camera $CAMERA --batch_size $BATCH_SIZE --steps_per_update $STEPS_PER_UPDATE --logdir $LOGDIR --db_filename $DB_FILENAME --frames_per_clip $FRAMES_PER_CLIP --n_epochs $N_EPOCHS --input_type $INPUT_TYPE --n_points $N_POINTS --pc_model $PC_MODEL --use_pointlettes $USE_POINTLETTES --pointlet_mode $POINTLET_MODE --n_gaussians $N_GAUSSIANS --correformer $CORREFORMER --cache_capacity $CACHE_CAPACITY
taskset -c 32-64 python test_i3d.py --dataset_path $DATASET_PATH --device $CAMERA --model_path $LOGDIR --batch_size 3 --db_filename $DATASET_PATH$DB_FILENAME --input_type $INPUT_TYPE --n_points $N_POINTS --pc_model $PC_MODEL --use_pointlettes $USE_POINTLETTES --pointlet_mode $POINTLET_MODE --model '000025.pt' --n_gaussians $N_GAUSSIANS --correformer $CORREFORMER
taskset -c 32-64 python3 ../evaluation/evaluate_ikeaasm.py --results_path $LOGDIR'results/' --dataset_path $DATASET_PATH --mode vid