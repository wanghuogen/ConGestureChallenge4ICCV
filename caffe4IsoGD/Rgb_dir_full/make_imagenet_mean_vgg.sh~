#!/usr/bin/env sh
# Compute the mean image from the imagenet training leveldb
# N.B. this is available in data/ilsvrc12
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
TOOLS=$CAFFERoot/build/tools
EXAMPLE=../Rgb_dir_full
DATA=../Rgb_dir_full
$TOOLS/compute_image_mean $EXAMPLE/RgbDIr_full_train_lmdb_vgg $DATA/RgbFull_dir_mean_vgg.binaryproto

echo "Done."
