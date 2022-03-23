FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN mkdir -p /var/run/sshd

RUN apt-get update && apt-get install sudo -y \
    nano \
    build-essential \
    openssh-server \
    python3 \
    python3-pip \
    python3-dev \
    git
RUN pip3 -q install pip --upgrade

RUN useradd -rm -d /home/development -s /bin/bash development && \
    echo "development:development" | chpasswd

RUN mkdir /home/development/.ssh/ && \
    chmod 700 /home/development/.ssh

COPY ssh_keys/id_rsa.pub /home/development/.ssh/authorized_keys

RUN chown development:development -R  /home/development/.ssh && \
    chmod 600 /home/development/.ssh/authorized_keys

WORKDIR /home/development
COPY requirements.txt /home/development
RUN chown development:development -R /home/development/

RUN pip install -r requirements.txt


