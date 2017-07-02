#!/usr/bin/env sh
# Compute the mean image from the imagenet training leveldb
# N.B. this is available in data/ilsvrc12
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
TOOLS=$CAFFERoot/build/tools
EXAMPLE=../Rgb_dir_fullbody
DATA=../Rgb_dir_fullbody
$TOOLS/compute_image_mean $EXAMPLE/RgbDIr_fullbody_train_lmdb_vgg $DATA/RgbFullbody_dir_mean_vgg.binaryproto

echo "Done."
