QB_CONF_FILE="/data/config/qBittorrent.conf"
BT_PORT=${BT_PORT:-34567}
WEBUI_PORT=${WEBUI_PORT:-8080}
API_KEY="qbt_$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 28)"

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

[WebUI]
APIKey=${API_KEY}
Port=${WEBUI_PORT}
EOF
fi

echo "Overriding required parameters..."
sed -i "{
    s!Session\\\Port=.*!Session\\\Port=${BT_PORT}!g;
    s!Port=.*!WebUI\\\Port=${WEBUI_PORT}!g;
}" $QB_CONF_FILE

if ! grep -q "^APIKey=" $QB_CONF_FILE; then
    sed -i "/^\[WebUI\]$/a APIKey=${API_KEY}" $QB_CONF_FILE
fi
