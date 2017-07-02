#!/usr/bin/env sh

../../build/tools/caffe train \
    --solver=solver_vgg.prototxt \
    --snapshot=caffenet_train_vgg_iter_30000.solverstate
