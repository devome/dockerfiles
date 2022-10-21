#!/bin/sh

groupmod -o -g "${PGID}" nginx
usermod -o -u "${PUID}" nginx
chown -R ${PUID}:${PGID} /home/nginxWebUI.jar /home/nginxWebUI /var/lib/nginx /var/log/nginx /run/nginx

cd /home
exec su-exec ${PUID}:${PGID} java -jar -Dfile.encoding=UTF-8 -Xmx64m nginxWebUI.jar ${BOOT_OPTIONS} >/dev/null
