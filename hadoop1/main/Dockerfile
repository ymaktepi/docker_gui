FROM library/ubuntu:latest

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get dist-upgrade -y

RUN apt-get install -y sudo x11-xserver-utils

RUN apt-get install -y gedit\
    rsync\
    ssh\
    openjdk-8-jdk\
    maven\
    unzip

RUN apt-get install -y firefox \
    curl

# Replace 1000 with your user / group id and set your username
RUN export uid=1000 gid=1000 developer=default_user && \
    mkdir -p /home/${developer} && \
    echo "${developer}:x:${uid}:${gid}:${developer},,,:/home/${developer}:/bin/bash" >> /etc/passwd && \
    echo "${developer}:x:${uid}:" >> /etc/group && \
    echo "${developer} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${developer} && \
    chmod 0440 /etc/sudoers.d/${developer} && \
    chown ${uid}:${gid} -R /home/${developer}


# fix the 254 error code, see https://github.com/sequenceiq/hadoop-docker/blob/master/Dockerfile
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config

USER default_user
ENV HOME /home/default_user
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
COPY script_xhost.sh /tmp/script_xhost.sh
RUN cat /tmp/script_xhost.sh >> /home/default_user/.bashrc
COPY hadoop-1.0.3.tar.gz /home/default_user/hadoop-1.0.3.tar.gz
RUN cd /home/default_user && \
    tar -xvf hadoop-1.0.3.tar.gz && \
    mv hadoop-1.0.3 hadoop && \
    echo 'JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/' >> hadoop/conf/hadoop-env.sh && \
    cp -r hadoop hadoop-dist &&\
    rm hadoop-1.0.3.tar.gz

COPY config.tar.gz /home/default_user/config.tar.gz
RUN cd /home/default_user &&\
    tar -xvf config.tar.gz &&\
    cp config/* hadoop-dist/conf/ &&\
    rm config.tar.gz

RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa &&\
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys &&\
    chmod 700 ~/.ssh/id_rsa.pub


RUN sudo service ssh restart

ENTRYPOINT echo "The container is ready!" && sleep 10000000
