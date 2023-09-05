#!/usr/bin/env bash

/usr/sbin/sshd -D
git config --global --add safe.directory /pose-estimation-playground
git config --global user.name "StevenAbbott"
git config --global user.email "sbabbott08@gmail.com"


cd /pose-estimation-playground

poetry env use /bin/python3.7

# For motionBERT:

# CPU only
pip install torch==1.13.1+cpu torchvision==0.14.1+cpu torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu
# CUDA 11.6
#RUN python3.7 -m pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116
pip install -r ./models/motionBERT/requirements.txt

# For AlphaPose:
pip install cython numpy ninja

cd /pose-estimation-playground/models/AlphaPose
python setup.py build develop --user