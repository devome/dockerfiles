#!/bin/sh

cd /IYUU

## 更新
# if [[ ! -d .git ]]; then
#     git clone https://github.com/ledccn/IYUUPlus.git /tmp/IYUU
#     #git clone https://gitee.com/ledc/iyuuplus.git /tmp/IYUU
#     find /tmp/IYUU -mindepth 1 -maxdepth 1 | xargs -I {} cp -r {} /IYUU
#     rm -rf /tmp/IYUU
# else
#     git fetch --all
#     git reset --hard origin/master
#     git pull
# fi

if [[ ! -s .env ]]; then
    cp -f .env.example .env
fi

if [ ! -d db ]; then
    mkdir db
fi

## 生成crontab
if [[ -z "${CRON_UPDATE}" ]]; then
    minute=$(($RANDOM % 60))
    hour_start=$(($RANDOM % 6))
    hour_interval=$(($RANDOM % 4 + 6))
    CRON_UPDATE="${minute} ${hour_start}-23/${hour_interval} * * *"
fi
crontmp=$(mktemp)
echo  "${CRON_UPDATE} cd /IYUU && git fetch --all && git reset --hard origin/master && git pull && php start.php restart -d" > $crontmp
#echo "设置crontab如下："
#cat $crontmp

## 重置权限
groupmod -o -g "${PGID}" iyuu
usermod -o -u "${PUID}" iyuu
chown -R ${PUID}:${PGID} $crontmp /IYUU
#su-exec ${PUID}:${PGID} crontab $crontmp
rm $crontmp

## 启动
su-exec ${PUID}:${PGID} php start.php start -d
exec crond -f
