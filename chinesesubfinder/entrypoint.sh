#!/bin/sh

chown -R "${PUID}:${PGID}" /config
echo "请自行在宿主上检查你设置的 'PUID=${PUID} PGID=${PGID}' 这个用户有你所设置媒体目录的读取和写入权限..."
echo "开始启动ChineseSubFinder，生成的日志、缓存、配置文件都保存在config目录下..."
umask ${UMASK:-022}
cd /config
exec su-exec "${PUID}:${PGID}" chinesesubfinder
