QB_CONF_FILE="/data/config/qBittorrent.conf"
QB_PASSWD_HASH=$(gen-qb-passwd "$QB_PASSWORD")
BT_PORT=${BT_PORT:-34567}
WEBUI_PORT=${WEBUI_PORT:-8080}

if [ ! -s $QB_CONF_FILE ]; then
    echo "Initializing qBittorrent configuration..."
    cat > $QB_CONF_FILE << EOF
[AutoRun]
enabled=true
program=dl-finish \"%K\"

[BitTorrent]
Session\DefaultSavePath=/data/downloads
Session\Port=${BT_PORT}
Session\TempPath=/data/temp

[LegalNotice]
Accepted=true

[Preferences]
General\Locale=zh_CN
WebUI\Password_PBKDF2=\"@ByteArray($QB_PASSWD_HASH)\"
WebUI\Port=${WEBUI_PORT}
WebUI\Username=${QB_USERNAME}
EOF
fi

echo "Overriding required parameters..."
sed -i "{
    s!Session\\\Port=.*!Session\\\Port=${BT_PORT}!g;
    s!WebUI\\\Port=.*!WebUI\\\Port=${WEBUI_PORT}!g;
    s!WebUI\\\LocalHostAuth=.*!WebUI\\\LocalHostAuth=true!g;
}" $QB_CONF_FILE

if [[ ${QB_USERNAME} == admin && $QB_PASSWORD == adminadmin ]]; then
    echo "Please set env QB_USERNAME and QB_PASSWORD to your own, do not set 'QB_USERNAME=admin' and 'QB_PASSWORD=adminadmin' ..."
    notify "nevinee/qbittorrent镜像重要更新说明" "为保证用户安全，防止用户因使用反代并代理了127.0.0.1这种情况导致安全性降低，从2023年9月6日更新的镜像开始，创建容器需要新增设置两个环境变量：\n\nQB_USERNAME（登陆qBittorrent的用户名）\nQB_PASSWORD（登陆qBittorrent的密码）\n\n容器将在创建时使用这两个环境变量去设置（如已存在配置文件则是修改）登陆qBittorent的用户名和密码。\n\n如未设置这两个环境变量，或者保持为qBittorrent的默认值（默认用户名：admin，默认密码：adminadmin），则本容器附加的所有脚本、定时任务将无法继续使用。\n\n详情：https://github.com/devome/dockerfiles/issues/101 \n\n本消息只在设置了有效的通知渠道，并且未设置有效的 QB_USERNAME 和 QB_PASSWORD 这两个环境变量时，在创建容器时自动发送一次。"
else
    sed -i "{
        s!WebUI\\\Username=.*!WebUI\\\Username=${QB_USERNAME}!;
        s!WebUI\\\Password_PBKDF2=.*!WebUI\\\Password_PBKDF2=\"@ByteArray($QB_PASSWD_HASH)\"!;
    }" $QB_CONF_FILE
fi

major_ver=$(qbittorrent-nox --version | sed 's|qBittorrent v||' | awk -F. '{print $1}')
minor_ver=$(qbittorrent-nox --version | sed 's|qBittorrent v||' | awk -F. '{print $2}')

if [[ $major_ver -eq 4 && $minor_ver -lt 5 ]]; then
    sed -i -E 's|General\\Locale=.+|General\\Locale=zh|' $QB_CONF_FILE
    sed -i -E 's|program=dl-finish \\"%K\\"|program=dl-finish \\"%I\\"|' $QB_CONF_FILE
else
    sed -i -E 's|General\\Locale=.+|General\\Locale=zh_CN|' $QB_CONF_FILE
fi
