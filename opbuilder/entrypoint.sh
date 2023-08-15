#!/usr/bin/bash

cmd="$@"

sudo update-ca-certificates

sudo groupmod -o -g "${PGID}" $USERNAME
sudo usermod -o -u "${PUID}" $USERNAME

if [[ $ENABLE_CHOWN == true ]]; then
    sudo chown -R "${PGID}:${PUID}" /home/$USERNAME
fi

if [[ -z $cmd ]]; then
    exec tail -f /dev/null
else
    eval "$cmd"
    exit 0
fi
