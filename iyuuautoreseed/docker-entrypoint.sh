#!/usr/bin/env bash

if [[ ! -d /iyuu/.git ]]; then
    git clone https://gitee.com/ledc/IYUUAutoReseed.git /iyuu
else
    git -C /iyuu pull
fi

if [[ ! -s /iyuu/config/config.php ]]; then
    cp /iyuu/config/config.sample.php /iyuu/config/config.php
fi

if [[ -z ${CRON_GIT_PULL} ]]; then
    CRON_GIT_PULL="23 7,19 * * *"
fi

if [[ -z ${CRON_IYUU} ]]; then
    CRON_IYUU="51 7,19 * * *"
fi

echo "设置cron..."
echo -e "${CRON_GIT_PULL} git -C /iyuu pull\n${CRON_IYUU} php /iyuu/iyuu.php" | crontab -

echo "当前crontab如下："
crontab -l

exec -- crond -f
