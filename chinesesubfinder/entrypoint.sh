#!/bin/sh

echo "下载最新配置示例文件..."
wget -q -O /config/config.yaml.sample.new https://cdn.jsdelivr.net/gh/allanpk716/ChineseSubFinder/config.yaml.sample
if [ $? -eq 0 ]; then
    mv /config/config.yaml.sample.new /config/config.yaml.sample
fi
if [ -f /config/config.yaml.sample.new ]; then
    rm -rf /config/config.yaml.sample.new
fi

if [ ! -s /config/config.yaml ]; then
    echo '文件 "/config/config.yaml" 不存在，复制一份...'
    if [ -f /config/config.yaml.sample ]; then
        cp -v /config/config.yaml.sample /config/config.yaml
    else
        cp -v /app/config.yaml.sample /config/config.yaml
    fi
else
    echo '文件 "/config/config.yaml" 已存在，使用该文件作为配置...'
fi

chown -R "${PUID}:${PGID}" /config
echo "启动ChineseSubFinder，生成的日志以及setting.db和config.yaml保存在一起..."
umask ${UMASK:-022}
cd /config
exec su-exec "${PUID}:${PGID}" chinesesubfinder
