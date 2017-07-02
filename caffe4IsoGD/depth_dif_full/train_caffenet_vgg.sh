#!/usr/bin/env sh
CAFFERoot=/home/huogen/git/caffe   #change to your caffe folder
TOOLS=$CAFFERoot/build/tools

$TOOLS/caffe train \
    --solver=solver-resnet50.prototxt\
    --weights=ResNet-50-model.caffemodel -gpu 0
echo "Done."
