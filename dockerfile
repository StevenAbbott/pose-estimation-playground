FROM nvidia/cuda:11.6.2-cudnn8-devel-ubuntu20.04

#FROM python:3.7-bookworm

ARG DEBIAN_FRONTEND=noninteractive

###
### 1: Setup SSH
###
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

COPY id_ed25519_pe_dev_2 /root/.ssh/id_ed25519_pe_dev_2
COPY id_ed25519_pe_dev_2.pub /root/.ssh/id_ed25519_pe_dev_2.pub
RUN chmod 700 /root/.ssh/
RUN chmod go-r /root/.ssh/id_ed25519_pe_dev_2

RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN echo "Host github.com\n\tIdentityFile /root/.ssh/id_ed25519_pe_dev_2" > /root/.ssh/config

RUN cat ~/.ssh/id_ed25519_pe_dev_2.pub >> ~/.ssh/authorized_keys

EXPOSE 22


###
### 2. Configure random stuff that should be configured
###

RUN apt-get install vim curl git -y --no-install-recommends

RUN apt-get update
RUN apt-get install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev wget libbz2-dev -y --no-install-recommends
RUN apt-get install software-properties-common -y --no-install-recommends
RUN add-apt-repository ppa:deadsnakes/ppa

RUN apt-get update -y && \
    apt-get install python3.7 python3.7-dev python3-pip python3.7-distutils -y --no-install-recommends

RUN python3.7 -m pip install pip
RUN #curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3.7 get-pip.py

RUN echo -e "\nalias python=/bin/python3.7" >> /root/.bashrc
RUN echo -e "\nalias pip='python3.7 -m pip'" >> /root/.bashrc
RUN echo -e "\nexport PATH='/root/.local/bin:$PATH'" >> /root/.bashrc

RUN alias python=/bin/python3.7
RUN alias pip='python3.7 -m pip'
RUN export PATH='/root/.local/bin:$PATH'

RUN curl -sSL https://install.python-poetry.org | python3 -


###
### 3. Clone model repos
###

RUN git clone https://github.com/Walter0807/MotionBERT.git motionBERT



###
### 4. Install dependencies
###

WORKDIR /pose-estimation-playground

RUN /root/.local/bin/poetry env use /bin/python3.7

# CPU only
RUN python3.7 -m pip install torch==1.13.1+cpu torchvision==0.14.1+cpu torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cpu \
# CUDA 11.6
#RUN python3.7 -m pip install torch==1.13.1+cu116 torchvision==0.14.1+cu116 torchaudio==0.13.1 --extra-index-url https://download.pytorch.org/whl/cu116

RUN python3.7 -m pip install -r /models/motionBERT/requirements.txt

























#CMD ["/usr/sbin/sshd", "-D"]