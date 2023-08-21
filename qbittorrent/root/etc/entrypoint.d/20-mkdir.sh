echo "Make some folders..."

cd /data
dirs1=( cache certs config data/logs downloads diy temp torrents watch webui ${QBT_PROFILE}/qBittorrent )
for dir in ${dirs1[@]}; do
    [ ! -d $dir ] && mkdir -p $dir
done

dirs2=( cache config data )
for dir in ${dirs2[@]}; do
    if [[ $(readlink -f ${QBT_PROFILE}/qBittorrent/$dir 2>/dev/null) != /data/$dir ]]; then
        rm -rf ${QBT_PROFILE}/qBittorrent/$dir
        ln -sf /data/$dir ${QBT_PROFILE}/qBittorrent/$dir
    fi
done

if [[ $(readlink -f /data/logs 2>/dev/null) != /data/data/logs ]]; then
    rm -rf /data/logs
    ln -sf data/logs logs
fi
