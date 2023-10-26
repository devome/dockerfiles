## 清除root的crontab
crontab -r

## health-check
if [[ -z ${CRON_HEALTH_CHECK} ]]; then
    CRON_HEALTH_CHECK="12 * * * *"
elif [[ ${CRON_HEALTH_CHECK} == off ]]; then
    CRON_HEALTH_CHECK=""
fi
if [[ -n "${CRON_HEALTH_CHECK}" ]]; then
    echo -e "# qbittorrent客户端健康检查\n${CRON_HEALTH_CHECK} health-check >> /data/diy/crond.log\n" > /tmp/crontab.list
fi

## tracker-error
if [[ -z ${CRON_TRACKER_ERROR} ]]; then
    CRON_TRACKER_ERROR="52 */4 * * *"
elif [[ ${CRON_TRACKER_ERROR} == off ]]; then
    CRON_TRACKER_ERROR=""
fi
if [[ -n "$CRON_TRACKER_ERROR" ]]; then
    echo -e "# Tracker出错检查\n${CRON_TRACKER_ERROR} tracker-error >> /data/diy/crond.log\n" >> /tmp/crontab.list
fi

## auto-cat
if [[ $ENABLE_AUTO_CATEGORY != false ]]; then
    if [[ -z ${CRON_AUTO_CATEGORY} ]]; then
        CRON_AUTO_CATEGORY="32 */2 * * *"
    fi
    echo -e "# 自动分类\n${CRON_AUTO_CATEGORY} auto-cat -a >> /data/diy/crond.log\n" >> /tmp/crontab.list
fi

## iyuu-help
if [[ -n "${CRON_IYUU_HELP}" ]]; then
    echo -e "# IYUU辅助任务，自动重校验、自动恢复做种\n${CRON_IYUU_HELP} iyuu-help >> /data/diy/crond.log\n" >> /tmp/crontab.list
fi

## detect-ip
if [[ -n "${MONITOR_IP}" ]]; then
    echo -e "# 每分钟检测局域网指定设备是否在线，若在线则启用备用速度限制\n* * * * * detect-ip &>/dev/null\n" >> /tmp/crontab.list
fi

## alter-limits，启用detect-ip时本项不生效
if [[ -z ${MONITOR_IP} ]] && [[ ${CRON_ALTER_LIMITS} ]]; then
    cron_alter_limits_on_all=$(echo "${CRON_ALTER_LIMITS}" | awk -F '|' '{print $1}')
    cron_alter_limits_on_sum=$(echo "${cron_alter_limits_on_all}" | awk -F ':' '{print NF}')
    task_alter_limits_on="# 启用备用速度限制"
    for ((i = 1; i <= $cron_alter_limits_on_sum; i++)); do
        cron_on_tmp=$(echo "${cron_alter_limits_on_all}" | awk -v var=$i -F ':' '{print $var}')
        task_alter_limits_on="$task_alter_limits_on\\n$cron_on_tmp alter-limits on >> /data/diy/crond.log"
    done
    echo -e "$task_alter_limits_on\n" >> /tmp/crontab.list

    cron_alter_limits_off_all=$(echo "${CRON_ALTER_LIMITS}" | awk -F '|' '{print $2}')
    cron_alter_limits_off_sum=$(echo "${cron_alter_limits_off_all}" | awk -F ':' '{print NF}')
    task_alter_limits_off="# 关闭备用速度限制"
    for ((i = 1; i <= $cron_alter_limits_off_sum; i++)); do
        cron_off_tmp=$(echo "${cron_alter_limits_off_all}" | awk -v var=$i -F ':' '{print $var}')
        task_alter_limits_off="$task_alter_limits_off\\n$cron_off_tmp alter-limits off >> /data/diy/crond.log"
    done
    echo -e "$task_alter_limits_off\n" >> /tmp/crontab.list
fi

## Set crontab
echo "Set crontab to system..."
su-exec "${PUID}:${PGID}" crontab /tmp/crontab.list
rm -f /tmp/crontab.list
