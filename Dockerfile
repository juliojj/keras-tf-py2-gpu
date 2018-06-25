# Keras, TensorFlow, Python2, cuda and cuDNN (GPU) and some extra packages (opencv, scipy, sklearn, etc)

FROM nvidia/cuda:9.0-cudnn7-runtime-ubuntu16.04

# fix cudnn version
USER root
RUN apt-get update && apt-get install -y --allow-downgrades --no-install-recommend$
libcudnn7=7.0.5.15-1+cuda9.1 \
libcudnn7-dev=7.0.5.15-1+cuda9.1 && \
rm -rf /var/lib/apt/lists/*
RUN apt-get update

# install packages
RUN apt-get update -qq \
 && apt-get install --no-install-recommends -y \
    # install essentials
    build-essential \
    git \
    # install python 2
    python \
    python-dev \
    python-pip \
    python-setuptools \
    python-wheel \
    pkg-config \
    # requirements for numpy
    libopenblas-base \
    python-numpy \
    python-scipy \
    # requirements for keras
    python-h5py \
    python-yaml \
    python-pydot \
    # extra packages
    vim \
    python-sklearn \
    ffmpeg \
    frei0r-plugins \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# update pip
RUN pip install --upgrade pip

# manually update numpy
RUN pip --no-cache-dir install -U numpy==1.13.3

ARG TENSORFLOW_VERSION=1.5.0
ARG TENSORFLOW_DEVICE=gpu
ARG TENSORFLOW_APPEND=_gpu
RUN pip --no-cache-dir install https://storage.googleapis.com/tensorflow/linux/${TENSORFLOW_DEVICE}/tensorflow${TENSORFLOW_APPEND}-${TENSORFLOW_VERSION}-cp27-none-linux_x86_64.whl

ARG KERAS_VERSION=2.1.4
ENV KERAS_BACKEND=tensorflow
RUN pip --no-cache-dir install --no-dependencies git+https://github.com/fchollet/keras.git@${KERAS_VERSION}

# install opencv
RUN pip install opencv-python

# debug
RUN pip install pudb

WORKDIR /root/
