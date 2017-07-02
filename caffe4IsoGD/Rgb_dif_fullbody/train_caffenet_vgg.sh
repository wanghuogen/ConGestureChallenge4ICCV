#!/usr/bin/env sh
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
TOOLS=$CAFFERoot/build/tools

$TOOLS/caffe train \
    --solver=solver-resnet50.prototxt\
    --weights=(NEED change to the model trained on Depth_dif_fullbody) -gpu 0
echo "Done."
