#!/usr/bin/env bash

for file in /etc/entrypoint.d/*.sh; do
    . "$file"
done

echo "Start crond..."
if [[ $(realpath /data/diy/crond.log) != /data/diy/crond.log ]]; then
    rm /data/diy/crond.log
fi
crond

echo "Start qbittorrent-nox..."
exec su-exec "${PUID}:${PGID}" qbittorrent-nox
