#!/usr/bin/env bash

## 1. 运行脚本的前提：已经安装docker、docker-pushrm、hub-tool，已经登陆docker和hub-tool；
## 2. 本地编译仍然会花费好几个小时；
## 3. 在Dockerfile同目录下运行；
## 4. 请使用root用户运行；
## 5. 宿主机安装好 moreutils 这个包；
## 6. 运行build.sh -h查看帮助

set -o pipefail

## 跨平台构建相关
prepare_buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
}

## 克隆脚本
git_clone() {
    if [[ ! -d libtorrent-${LIBTORRENT_VERSION} ]]; then
        git clone --branch v${LIBTORRENT_VERSION} ${LIBTORRENT_URL} libtorrent-${LIBTORRENT_VERSION}
    else
        echo "本地已经克隆好了"
    fi
}

## 构建
docker_build() {
    for ((c=1; c<=${BUILD_COUNT}; c++)); do
        echo "============================= 第 $c 次构建尝试 ============================="
        ./buildx-build.sh && break
    done
}

## 推送
docker_push() {
    for arch in ${BUILDX_ARCH}; do
        docker push ${DOCKERHUB_REPOSITORY}:${LIBTORRENT_VERSION}-${arch//\//-}
    done
}

## 维护标签
docker_manifest() {
    for ((n=1; n<=${MANIFEST_COUNT}; n++)); do
        echo "============================= 第 $n 次信息维护 ============================="
        for tag in ${MULTITAGS}; do
            docker manifest create "${DOCKERHUB_REPOSITORY}:${tag}" "${IMAGES[@]}"
            docker manifest push --purge "${DOCKERHUB_REPOSITORY}:${tag}"
        done
    done
}

## 删除单平台标签，需要先安装好hub-tool：https://github.com/docker/hub-tool
del_tag() {
    for image in ${IMAGES[@]}; do
        hub-tool tag rm --verbose -f $image
    done
}

## 基础函数
base_func() {
    cd $(dirname $0)
    [[ ! -d logs ]] && mkdir logs

    ## 版本、仓库名、网址等
    export DOCKER_CLI_EXPERIMENTAL=enabled
    export LATEST_VERSION=$(curl -s https://api.github.com/repos/arvidn/libtorrent/tags | jq -r .[]."name" | grep -m1 -E "v([0-9]{1,2}\.?){3,4}$" | sed "s/v//")

    [[ $ver ]] && export LIBTORRENT_VERSION=$ver || export LIBTORRENT_VERSION=${LATEST_VERSION}
    [[ $repo ]] && export DOCKERHUB_REPOSITORY=$repo || export DOCKERHUB_REPOSITORY=nevinee/libtorrent-rasterbar
    [[ $filename ]] && export DOCKERFILE_NAME=${filename} || export DOCKERFILE_NAME=Dockerfile
    [[ $url ]] && export LIBTORRENT_URL=$url || export LIBTORRENT_URL=https://gitee.com/evine/libtorrent.git
    [[ $bcount ]] && export BUILD_COUNT=$bcount || export BUILD_COUNT=20
    [[ $mcount ]] && export MANIFEST_COUNT=$mcount || export MANIFEST_COUNT=1
    [[ $jnproc ]] && export JNPROC=$jnproc || export JNPROC=1
    [[ $archtech ]] && export BUILDX_ARCH="$archtech" || export BUILDX_ARCH="386 amd64 arm64 arm/v6 arm/v7 ppc64le s390x"

    ## 标签
    MAJOR_VERSION=$(echo ${LIBTORRENT_VERSION} | perl -pe "s|^(\d+)\..+|\1|")
    MULTITAGS="${LIBTORRENT_VERSION} ${MAJOR_VERSION}"

    ## 单平台标签数组
    IMAGES=()
    for arch in ${BUILDX_ARCH}; do
        IMAGES+=( "${DOCKERHUB_REPOSITORY}:${LIBTORRENT_VERSION}-${arch//\//-}" )
    done
}

## 输出
echo_console() {
    echo "控制变量如下："
    echo "LIBTORRENT_VERSION=${LIBTORRENT_VERSION}"
    echo "DOCKERHUB_REPOSITORY=${DOCKERHUB_REPOSITORY}"
    echo "DOCKERFILE_NAME=${DOCKERFILE_NAME}"
    echo "LIBTORRENT_URL=${LIBTORRENT_URL}"
    echo "BUILDX_ARCH='${BUILDX_ARCH}'"
    echo "MULTITAGS='${MULTITAGS}'"
    echo "JNPROC=${JNPROC}"
    echo "IMAGES[@]='${IMAGES[@]}'"
}

## 用法
usage() {
    echo "可接受选项："
    echo "-a <action>    # 可用动作见下，默认all"
    echo "-b             # 针对unstable版本，仅推送'unstable'标签，不推送版本标签"
    echo "-c <bcount>    # 构建镜像尝试次数上限，默认20"
    echo "-d <dockfile>  # Dockerfile文件路径，默认Dockerfile"
    echo "-j <jnproc>    # 用来编译的核心数，默认1"
    echo "-l <yes/no>    # 是否记录日志[YES|Yes|yes|y / NO|No|no|n]，默认yes"
    echo "-n <mcount>    # 信息维护次数，默认1"
    echo "-r <hubrepo>   # 构建镜像名（不含标签），默认nevinee/libtorrent-rasterbar"
    echo "-t <archtech>  # 构建架构，默认全构架"
    echo "-u <giturl>    # 克隆代码网址，默认https://gitee.com/evine/libtorrent.git"
    echo "-v <version>   # 构建版本，默认最新稳定版"
    echo
    echo "其中'-a'选项可接受的动作："
    echo "A|all                   # 克隆代码、构建镜像、推送镜像、维护信息、删除标签(默认值)"
    echo "a|all_except_deltag     # 克隆代码、构建镜像、推送镜像、维护信息"
    echo "c|clone                 # 克隆代码"
    echo "b|build                 # 克隆代码、构建镜像"
    echo "p|push                  # 推送镜像"
    echo "P|push_manifest         # 推送镜像、维护信息"
    echo "Q|push_manifest_deltag  # 推送镜像、维护信息、删除标签"
    echo "m|manifest              # 维护信息"
    echo "M|manifest_deltag       # 维护信息、删除标签"
    echo "d|deltag                # 删除标签"
}

## 运行
run() {
    case $1 in
        a | all_except_deltag) # 克隆代码、构建镜像、推送镜像、更新教程、维护信息
            echo_console
            echo "BUILD_COUNT=${BUILD_COUNT}"
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            prepare_buildx
            git_clone
            docker_build && {
                docker_push
                docker_manifest
                docker_pushrm
            } || {
                echo "构建失败，不推送镜像，不维护信息，退出！"
                exit 4
            }
            ;;
        A | all) # 克隆代码、构建镜像、推送镜像、维护信息、更新教程、删除标签
            echo_console
            echo "BUILD_COUNT=${BUILD_COUNT}"
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            prepare_buildx
            git_clone
            docker_build && {
                docker_push
                docker_manifest
                docker_pushrm
                del_tag
            } || {
                echo "构建失败，不推送镜像，不维护信息，退出！"
                exit 4
            }
            ;;
        b | build) # 克隆代码、构建镜像
            echo_console
            echo "BUILD_COUNT=${BUILD_COUNT}"
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            prepare_buildx
            git_clone
            docker_build
            ;;
        d | deltag) # 删除标签
            echo_console
            del_tag
            ;;
        c | clone) # 克隆代码
            echo_console
            git_clone
            ;;
        m | manifest) # 维护信息
            echo_console
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            docker_manifest
            ;;
        M | manifest_deltag) # 维护信息、删除标签
            echo_console
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            docker_manifest
            del_tag
            ;;
        p | push) # 推送镜像
            echo_console
            docker_push
            ;;
        P | push_manifest) # 推送镜像、维护信息
            echo_console
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            docker_push
            docker_manifest
            ;;
        Q | push_manifest_deltag) # 推送镜像、维护信息、删除标签
            echo_console
            echo "MANIFEST_COUNT=${MANIFEST_COUNT}"
            docker_push
            docker_manifest
            del_tag
            ;;
    esac
}

## 主函数
main() {
    while getopts :a:bc:f:j:l:n:r:t:u:v: opt; do
        case $opt in
            # 传入参数
            a) action=$OPTARG;;
            b) onlyunstable=yes;;
            c) bcount=$OPTARG;;
            f) filename=$OPTARG;;
            j) jnproc=$OPTARG;;
            l) log=$OPTARG;;
            n) mcount=$OPTARG;;
            r) repo=$OPTARG;;
            t) archtech=$OPTARG;;
            u) url=$OPTARG;;
            v) ver=$OPTARG;;

            # 帮助
            ?) usage; exit 1;;
        esac
    done
    shift $((OPTIND - 1))
    [[ $1 ]] && usage && exit 2
    [[ -z $action ]] && action=all
    [[ -z $log ]] && log=yes
    case $action in
        A|all|a|all_except_deltag|c|clone|b|build|p|push|P|push_manifest|Q|push_manifest_deltag|m|manifest|M|manifest_deltag|d|deltag)
            base_func
            case $log in
                YES|Yes|yes|y) run $action 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${LIBTORRENT_VERSION}.log;;
                NO|No|no|n)    run $action 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]";;
            esac
            ;;
        *)
            usage
            exit 3
            ;;
    esac
}

main "$@"
