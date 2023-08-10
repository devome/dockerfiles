#!/usr/bin/bash

cmd="$@"

sudo update-ca-certificates

sudo groupmod -o -g "${PGID}" $USERNAME
sudo usermod -o -u "${PUID}" $USERNAME
sudo chown -R "${PGID}:${PUID}" /home/$USERNAME

if [[ -z $cmd ]]; then
    exec tail -f /dev/null
else
    eval "$cmd"
    exit 0
fi
