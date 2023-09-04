FROM nvidia/cuda:11.7.1-devel-ubuntu22.04

#FROM python:3.7-bookworm


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

RUN apt-get install vim curl -y --no-install-recommends

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

RUN curl -sSL https://install.python-poetry.org | python3 -


###
### 3. Install dependencies
###

WORKDIR /pose-estimation-playground


RUN #poetry env use /bin/python3.7

#RUN python3.7 -m venv pe-env
#RUN source pe-env/bin/activate


























#CMD ["/usr/sbin/sshd", "-D"]