#!/bin/sh

if [ ! -s /config/subfinder.json ]; then
    echo '文件 "/config/subfinder.json" 不存在，使用默认配置...'
    echo 'ewogICJleHRzIjogWyJhc3MiLCAic3J0Il0sCiAgIm1ldGhvZCI6IFsiemltdWt1IiwgInN1YmhkIiwgInNob290ZXIiXSwKICAidmlkZW9fZXh0cyI6IFsiLm1rdiIsICIubXA0IiwgIi50cyIsICIuaXNvIl0sCiAgImFwaV91cmxzIjogewogICAgInppbXVrdSI6ICJodHRwczovL3d3dy56aW11a3UucHcvc2VhcmNoIiwKICAgICJzdWJoZCI6ICJodHRwczovL3N1YmhkLnR2L3NlYXJjaCIsCiAgICAic3ViaGRfYXBpX3N1YnRpdGxlX2Rvd25sb2FkIjogIi9hamF4L2Rvd25fYWpheCIsCiAgICAic3ViaGRfYXBpX3N1YnRpdGxlX3ByZXZpZXciOiAiL2FqYXgvZmlsZV9hamF4IgogIH0KfQoK' | base64 -d > /config/subfinder.json
else
    echo '文件 "/config/subfinder.json" 已存在，使用该文件作为配置...'
fi

chown -R "${PUID}:${PGID}" /config
umask ${UMASK:-022}
exec su-exec "${PUID}:${PGID}" loop -e ${INTERVAL} -- subfinder -c /config/subfinder.json /media
