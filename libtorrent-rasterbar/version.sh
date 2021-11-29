#!/usr/bin/env bash

set -o pipefail

dir_shell=$(cd $(dirname $0); pwd)
dir_myscripts=$(cd $(dirname $0); cd ../../myscripts; pwd)

cd $dir_shell

## 官方版本
lib_tag=$(curl -s --retry 5 --retry-delay 8 https://api.github.com/repos/arvidn/libtorrent/tags)
ver_lib1_official=$(echo $lib_tag | jq -r .[].name | grep -m1 -E "v1(\.[0-9]+){2,3}$" | sed "s/v//")
ver_lib2_official=$(echo $lib_tag | jq -r .[].name | grep -m1 -E "v2(\.[0-9]+){2,3}$" | sed "s/v//")

## 本地版本
ver_lib1_local=$(cat 1.x.version)
ver_lib2_local=$(cat 2.x.version)

## 导入通知程序及配置
. $dir_myscripts/notify.sh
. $dir_myscripts/my_config.sh

## 检测官方版本与本地版本是否一致，如不一致则发出通知
build_mark_1=0
if [[ $ver_lib1_official ]]; then
    if [[ $ver_lib1_official != $ver_lib1_local ]]; then
        echo "官方已升级libtorrent-1.x版本至：$ver_lib1_official"
        notify "libtorrent-1.x已经升级" "当前官方版本: ${ver_lib1_official}\n当前本地版本: ${ver_lib1_local}"
        echo "$ver_lib1_official" > 1.x.version
        build_mark_1=1
    else
        echo -e "libtorrent-1.x版本无变化，均为${ver_lib1_official}"
    fi
fi

build_mark_2=0
if [[ $ver_lib2_official ]]; then
    if [[ $ver_lib2_official != $ver_lib2_local ]]; then
        echo "官方已升级libtorrent-2.x版本至：$ver_lib2_official"
        notify "libtorrent-2.x已经升级" "当前官方版本: ${ver_lib2_official}\n当前本地版本: ${ver_lib2_local}"
        echo "$ver_lib2_official" > 2.x.version
        build_mark_2=1
    else
        echo -e "libtorrent-2.x版本无变化，均为${ver_lib2_official}"
    fi
fi

## 需要更新时则重新构建
if [[ $build_mark_1 -eq 1 ]]; then
    ./buildx.sh -v$ver_lib1_official
fi

if [[ $build_mark_2 -eq 1 ]]; then
    ./buildx.sh -v$ver_lib2_official
fi
