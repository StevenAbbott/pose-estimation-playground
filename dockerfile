FROM python:3.7-bookworm

#
#ARG SSH_PRIVATE_KEY=$SSH_PRIVATE_KEY
#ARG SSH_PUB_KEY=$SSH_PUB_KEY



RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile



#RUN echo hello
#RUN ls /pe-dev-ssh
#RUN meep=$(ls /root) && echo $meep
RUN #ls /
COPY /home/sbabb/.ssh/pe-dev-ssh/id_ed25519_pe_dev.pub ~/.ssh/
#COPY ~/.ssh/pe-dev-ssh/id_ed25519_pe_dev.pub ~/.ssh/

#RUN cp /pe-dev-ssh/id_ed25519_pe_dev.pub ~/.ssh/
#RUN cat ~/.ssh/id_ed25519_pe_dev.pub >> ~/.ssh/known_hosts

#RUN echo ls /run/secrets
#RUN cp -r ~/.ssh/pe-dev-ssh/id_ed25519_pe_dev /run/secrets/host_dev_ssh_key




#RUN rm -r /root/.ssh/ &&\
#    mkdir /root/.ssh/ &&\
#    echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_ed25519 &&\
#    echo "${SSH_PUB_KEY}" > /root/.ssh/id_ed25519.pub &&\
#    chmod 600 /root/.ssh/id_ed25519 &&\
#    touch /root/.ssh/known_hosts &&\
#    ssh-keyscan github.com >> /root/.ssh/known_hosts
#
#RUN echo "Host remotehost\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config


EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash", "-c", "cat /pe-dev-ssh/id_ed25519_pe_dev.pub >> ~/.ssh/known_hosts;/usr/sbin/sshd", "-D"]