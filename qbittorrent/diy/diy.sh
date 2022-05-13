#!/usr/bin/env bash

## 使用本脚本有两种方式：

## 方式一：先向jellyfin/emby触发刮削操作，并在资源同目录下写入nfo（jellyfin/emby必须在刮削之前将媒体库设置中“媒体资料储存方式”勾选“nfo”），然后再向chinesesubfinder触发字幕下载。
## 如果种子中本来存在同名nfo，直接采用方式一会被破坏导致无法做种，如不想被覆盖，可在在运行下面的内容之前，先用其他命令行工具自动建立硬连接到其他文件夹，让jellyfin/emby、chinesesubfinder都只处理硬连接后的文件夹，或者直接采用方式二。
## 注意：如果硬连接了，硬连接后的视频文件名和它所在的文件夹名，须和原始文件名/文件夹名结构保持一致，如果不一致，无法使用本脚本。
## 注意：所有变量必须都赋值。

## 方式二：直接向chinesesubfinder触发字幕下载，但在同目录下缺少影视信息nfo的前提下，可能下载的字幕会不准确。
## chinesesubfinder不太建议采用这种方式，详见：https://github.com/allanpk716/ChineseSubFinder/blob/docs/DesignFile/ApiKey%E8%AE%BE%E8%AE%A1/ApiKey%E8%AE%BE%E8%AE%A1.md#%E6%96%B0%E5%A2%9E%E4%B8%80%E4%B8%AA%E4%BB%BB%E5%8A%A1
## 如采用方式二，这三个变量请不要赋值：media_server_url、media_server_token、delay。

## jellyfin/emby的访问地址，如果是在同一个容器网络，可以是172.x.x.x或主机名，主机名需要自行在创建容器时设置
## 示例1（HTTP+IP）：media_server_url="http://10.0.0.18:8096"
## 示例2（HTTPS+IP）：media_server_url="https://10.0.0.18:8920"
## 示例3（HTTP+域名）：media_server_url="http://nas.example.com:8096"
## 示例4（HTTPS+域名）：media_server_url="https://nas.example.com:8920"
## 示例5（HTTP+主机名）：media_server_url="http://jellyfin:8096"
## 示例6（HTTPS+主机名）：media_server_url="https://jellyfin:8920"
## 采用方式二时不要赋值
media_server_url=""

## 从jellyfin/emby控制台处获取的api密钥；
## 采用方式二时不要赋值。
media_server_token=""

## 向jellyfin/emby触发刮削操作和向chinesesubfinder触发字幕下载之间的间隔，采用方式一时有效；
## 由于每个人的资源库大小不一，从向jellyfin/emby触发刮削操作到jellyfin/emby完成刮削时间不一样，因此建议用户自行观察一下，触发刮削后媒体库需要花多少时间刮削完，其确保已经写入nfo；
## 采用方式二时不要赋值；
## 单位：秒。
delay="30"

## chinesesubfinder的访问地址，形式同上面的media_server_url
csf_url=""

## 从chinesesubfinder webui中获取的apikey，从v0.26.0起才有，老版本没有
csf_token=""

## 需要排除的关键字，不区分大小写，如果视频文件名中含有所设置的关键字，则该文件不会向chinesesubfidner提交字幕下载，多个关键字之间使用"|"分隔
ignore_keyword="sample|bonus|trailer"

## chinesesubfinder中设置的允许下载字幕的视频后缀，默认是mp4 mkv rmvb iso，如有修改，请同步调整下面的数组。
video_exts=( mp4 mkv rmvb iso )

## qbittorrent的下载目录和chinesesubfidner媒体目录的对应关系数组；
## 资源保存目录不在这个对应关系清单中的，就不会触发chinesesubfinder；
## 一行一个对应关系，用半角冒号(:)分隔，每一个对应关系使用双引号引起来，目录允许含有空格（但不建议）；
## 第一个冒号前是该目录的类型，0代表电影，1代表电视剧，详见：https://github.com/allanpk716/ChineseSubFinder/blob/docs/DesignFile/ApiKey%E8%AE%BE%E8%AE%A1/ApiKey%E8%AE%BE%E8%AE%A1.md
## 第二个冒号前的是qbittorrent的目录，第二个冒号后的是chinesesubfinder的目录，一一对应；
## 如果有硬连接，第二个冒号前应该是硬连接前qbittorrent下载保存的路径，第二个冒号后应该是硬连接后chinesesubfinder可识别的路径；
## 如 qb2csf_dir_match=(
##     "0:/movies1:/media/movies"
##     "0:/movies2:/media/movies"
##     "1:/tv:/media/tv"
## )
qb2csf_dir_match=(
    ""
)


########################## 以上为配置部分，以下为运行部分  ########################## 


## 如果资源保存目录不在qb2csf_dir_match填写的目录对应关系清单中的，直接退出
hash="$1"
[[ -z $api_url_base ]] && api_url_base="${qb_url}/api/v2"
content_path=$(curl -sSk "${api_url_base}/torrents/info?hashes=${hash}" | jq -r .[0].content_path)
is_match=no
for ((j=0; j<${#qb2csf_dir_match[*]}; j++)); do
    match_before=$(echo ${qb2csf_dir_match[i]} | awk -F ':' '{print $2}')
    if [[ "$content_path" == "$match_before/"* ]]; then
        is_match=yes
        break
    fi
done
if [[ $is_match == no ]]; then
    exit 0
fi

## 触发jellyfin/emby扫描资源库，输出的 http code 含义分别见：
## emby: http://swagger.emby.media/?staticview=true#/LibraryService/postLibraryRefresh
## jellyfin: https://api.jellyfin.org/#operation/RefreshLibrary
## 比如 emby 是 200 代表成功，而 jellyfin 则是 204 代表成功，如果输出 401 则是你给的 token 不对。
## 似乎/Library/Media/Updated这个api没法达到指定视频文件路径更新的效果，所以用的全量扫描Library/Refresh这个api。
## 有变化的文件不多的情况下，/Library/Refresh也能快速的扫描完成，扫描文件其实很快的，但在刮削时受制于和tmdb-api的连接性，可能会较慢，在向chinesesubfinder发起请求前，需要等待刮削完成。
echo "向 media server 触发媒体库扫描指令..."
if [[ -n $media_server_url && -n $media_server_token ]]; then
    curl -ik \
        -H "Content-Type: application/json" \
        -H "X-Emby-Token: ${media_server_token}" \
        -X POST \
        "${media_server_url}/Library/Refresh"
    echo "等待 $delay 秒后再向 ChineseSubFinder 发起字幕下载请求..."
    sleep $delay
fi

## chinesesubfinder中设置的视频后缀，默认是 mp4 mkv rmvb iso
if [[ ${#video_exts[*]} -eq 0 ]]; then
    video_exts=( mp4 mkv rmvb iso )
fi

## 寻找刚刚下载完成的资源中，所有设置的视频后缀video_exts的文件路径，转换为chinesesubfinder可识别的路径，并提交字幕下载
fdtmp="-iname *.${video_exts[0]}"
for ((i=1; i<${#video_exts[*]}; i++)); do fdtmp="$fdtmp -o -iname *.${video_exts[i]}"; done
tmplist=$(mktemp)
find "$content_path" \( $fdtmp \) > $tmplist
cat $tmplist | grep -Evi "$ignore_keyword" | while read file; do
    for ((j=0; j<${#qb2csf_dir_match[*]}; j++)); do
        match_before=$(echo ${qb2csf_dir_match[i]} | awk -F ':' '{print $2}')
        if [[ "$file" == "$match_before/"* ]]; then
            video_type=$(echo ${qb2csf_dir_match[i]} | awk -F ':' '{print $1}')
            match_after=$(echo ${qb2csf_dir_match[i]} | awk -F ':' '{print $3}')
            csf_file=$(echo "$file" | sed "s|$match_before|$match_after|")
            csf_result=$(curl -sSk \
                -H "Content-Type: application/json" \
                -H "Authorization: Bearer $csf_token" \
                -X POST \
                -d "{\"video_type\":$video_type,\"physical_video_file_full_path\":\"$csf_file\",\"task_priority_level\":3}" \
                "${csf_url}/api/v1/add-job"
            )
            csf_job_id=$(echo $csf_result | jq -r .job_id)
            csf_message=$(echo $csf_result | jq -r .message)
            echo "视频类型：${video_type}，qB的文件：${file}，对应CSF的文件：${csf_file}，CSF任务ID：${csf_job_id}，CSF任务消息：${csf_message}"
            break
        fi
    done
    sleep 0.3
done
rm $tmplist
