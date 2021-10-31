#!/bin/sh

set -e

if [[ -n "$SSH_PRIVATE_KEY" ]]
then
    mkdir -p /root/.ssh
    echo "$SSH_PRIVATE_KEY" > /root/.ssh/id_rsa
    chmod 600 /root/.ssh/id_rsa
fi

if [[ -n "$SSH_KNOWN_HOSTS" ]]
then
    mkdir -p /root/.ssh
    echo "StrictHostKeyChecking yes" >> /etc/ssh/ssh_config
    echo "$SSH_KNOWN_HOSTS" > /root/.ssh/known_hosts
    chmod 600 /root/.ssh/known_hosts
else
    echo "WARNING: StrictHostKeyChecking disabled"
    echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
fi

mkdir -p ~/.ssh
cp /root/.ssh/* ~/.ssh/ 2> /dev/null || true

sh -c "/git-mirror.sh $*"