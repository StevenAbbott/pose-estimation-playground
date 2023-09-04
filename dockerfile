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
git config --global

RUN cat ~/.ssh/id_ed25519_pe_dev_2.pub >> ~/.ssh/authorized_keys

EXPOSE 22


###
### 2. Configure random stuff that should be configured
###



###
### 3. Install dependencies
###

WORKDIR /pose-estimation-playground

RUN python -m venv pe-env
RUN source pe-env/bin/activate


























#CMD ["/usr/sbin/sshd", "-D"]