cd /iyuu

## 更新一次IYUU
if [[ ! -d .git ]]; then
    echo "Clone IYUUAutoReseed script..."
    rm -rf /iyuu/* 2>/dev/null
    git clone ${IYUU_REPO_URL} /tmp/iyuu
    find /tmp/iyuu -mindepth 1 -maxdepth 1 | xargs -I {} cp -r {} /iyuu
    rm -rf /tmp/iyuu
else
    echo "Update IYUUAutoReseed script..."
    git remote set-url origin ${IYUU_REPO_URL}
    git fetch --all
    git reset --hard origin/master
    git pull
fi

## 复制.env
if [[ ! -s .env ]]; then
    cp -f .env.example .env
fi

## 创建/data/iyuu_db文件夹，并软连接到/iyuu/db
IYUU_DB=/data/iyuu_db
[ ! -d ${IYUU_DB} ] && mkdir ${IYUU_DB}
if [[ $(readlink -f /iyuu/db 2>/dev/null) != ${IYUU_DB} ]]; then
    rm -rf /iyuu/db 2>/dev/null
    ln -sf ${IYUU_DB} /iyuu/db
fi

get_qb_url() {
    local is_ssl=$(grep -i "WebUI\\\HTTPS\\\Enabled=" /data/config/qBittorrent.conf | awk -F "=" '{print $2}')
    local url_prefix

    if [[ $is_ssl == true ]]; then
        url_prefix="https://"
    else
        url_prefix="http://"
    fi

    local qb_url="${url_prefix}127.0.0.1:${WEBUI_PORT}"
    echo "$qb_url"
}

## 写入/data/iyuu_db/clients.json
CLIENT_FILE=/data/iyuu_db/clients.json
HOST=$(get_qb_url | sed "s|/|\\\\\\\/|g")
if [[ ! -s ${CLIENT_FILE} ]]; then
    cur_timestamp=$(( $(date +'%s') * 1000 + $RANDOM % 1000 ))
    PID="pid$$_${cur_timestamp}"
    CLIENT_INFO="eyJQSUQiOnsidHlwZSI6InFCaXR0b3JyZW50IiwidXVpZCI6IlBJRCIsIm5hbWUiOiJsb2NhbGhvc3QiLCJob3N0IjoiSE9TVCIsImVuZHBvaW50IjoiIiwidXNlcm5hbWUiOiJRQl9VU0VSTkFNRSIsInBhc3N3b3JkIjoiUUJfUEFTU1dPUkQiLCJkb2NrZXIiOiJvbiIsImRlZmF1bHQiOiJvbiIsInJvb3RfZm9sZGVyIjoib24iLCJ3YXRjaCI6IlwvZGF0YVwvd2F0Y2giLCJkb3dubG9hZHNEaXIiOiJcL2RhdGFcL2Rvd25sb2FkcyIsIkJUX2JhY2t1cCI6IlwvZGF0YVwvZGF0YVwvQlRfYmFja3VwIn19"
    echo -en "$CLIENT_INFO" | base64 -d > ${CLIENT_FILE}
    chmod 666 ${CLIENT_FILE}
    sed -i "{s#PID#$PID#g; s#HOST#$HOST#g;}" ${CLIENT_FILE}
    if [[ ${QB_USERNAME} != admin || $QB_PASSWORD != adminadmin ]]; then
        sed -i "{
            s|QB_USERNAME|${QB_USERNAME}|g;
            s|QB_PASSWORD|${QB_PASSWORD}|g;
        }" ${CLIENT_FILE}
    fi
else
    sed -i "{
        s|\(\"host\":\"\)[^\"]*127\.0\.0\.1[^\"]*\(\"\)|\1$HOST\2|g;
        s|\(\"username\":\"\)[^\"]*\(\"\)|\1${QB_USERNAME}\2|g;
        s|\(\"password\":\"\)[^\"]*\(\"\)|\1${QB_PASSWORD}\2|g;
    }" ${CLIENT_FILE}
fi

## 以Daemon形式启动IYUU
chown -R "${PUID}:${PGID}" ${IYUU_DB} /iyuu
su-exec "${PUID}:${PGID}" php start.php start -d
