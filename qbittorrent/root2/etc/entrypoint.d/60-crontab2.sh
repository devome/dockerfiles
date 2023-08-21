## 补充IYUU更新脚本并重启程序的的cron
minute=$(($RANDOM % 60))
hour_start=$(($RANDOM % 6))
hour_interval=$(($RANDOM % 4 + 6))
CRON_UPDATE="${minute} ${hour_start}-23/${hour_interval} * * *"
echo -e "$(su-exec "${PUID}:${PGID}" crontab -l)\n\n# 更新并重启IYUU\n${CRON_UPDATE} cd /iyuu && git fetch --all && git reset --hard origin/master && git pull && php start.php restart -d >> /data/diy/crond.log" | su-exec "${PUID}:${PGID}" crontab -
