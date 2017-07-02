#!/usr/bin/env sh
# Compute the mean image from the imagenet training leveldb
# N.B. this is available in data/ilsvrc12
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
EXAMPLE=../depth_dir_full
TOOLS=$CAFFERoot/build/tools
DATA=../depth_dir_full
$TOOLS/compute_image_mean $EXAMPLE/DepthDIr_full_train_lmdb_vgg $DATA/DepthFull_dir_mean_vgg.binaryproto

echo "Done."
