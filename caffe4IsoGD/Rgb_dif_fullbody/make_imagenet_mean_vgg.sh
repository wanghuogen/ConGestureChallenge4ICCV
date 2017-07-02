#!/usr/bin/env sh
# Compute the mean image from the imagenet training leveldb
# N.B. this is available in data/ilsvrc12
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
TOOLS=$CAFFERoot/build/tools
EXAMPLE=../Rgb_dif_fullbody
DATA=../Rgb_dif_fullbody
$TOOLS/compute_image_mean $EXAMPLE/RgbDIf_fullbody_train_lmdb_vgg $DATA/RgbFullbody_dif_mean_vgg.binaryproto

echo "Done."
