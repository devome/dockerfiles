#!/usr/bin/bash

sudo update-ca-certificates

sudo groupmod -o -g "${PGID}" $USERNAME
sudo usermod -o -u "${PUID}" $USERNAME
sudo chown -R "${PGID}:${PUID}" /home/$USERNAME

exec tail -f /dev/null
