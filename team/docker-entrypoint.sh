#!/bin/bash
set -e

crond

if [[ -s /root/config/crontab.list ]]; then
  echo -e "检测到 /root/config/crontab.list 存在，自动导入定时任务...\n"
  crontab /root/config/crontab.list
  echo -e "成功添加定时任务...\n"
else
  echo -e "/root/config/crontab.list 不存在..."
fi

if [[ -s /root/panel/server.js && -d /root/panel/node_modules ]]; then
  pm2 start /root/panel/server.js
  echo -e "控制面板启动成功...\n"
else
  echo "控制面板未启动，请检查..."
fi

if [ "${1#-}" != "${1}" ] || [ -z "$(command -v "${1}")" ]; then
  set -- node "$@"
fi

exec "$@"
