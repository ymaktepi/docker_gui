FROM kalilinux/kali-linux-docker:latest

RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" > /etc/apt/sources.list

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove --purge

RUN apt-get install -y sudo gedit xorg openbox x11-xserver-utils

# Replace 1000 with your user / group id and set your username
RUN export uid=1000 gid=1000 developer=default_user && \
    mkdir -p /home/${developer} && \
    echo "${developer}:x:${uid}:${gid}:${developer},,,:/home/${developer}:/bin/bash" >> /etc/passwd && \
    echo "${developer}:x:${uid}:" >> /etc/group && \
    echo "${developer} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${developer} && \
    chmod 0440 /etc/sudoers.d/${developer} && \
    chown ${uid}:${gid} -R /home/${developer}


USER ${developer}
ENV HOME /home/${developer}

ENTRYPOINT xhost local:root && sleep 10000000
