ARG CODENAME=jammy
FROM ubuntu:${CODENAME}
ARG DEBIAN_FRONTEND=noninteractive
ARG CODENAME
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash \
    LANG=C.UTF-8 \
    PS1="\u@\h:\w \$ " \
    TZ=Asia/Shanghai
RUN apt update \
    && apt upgrade -y \
    && apt install -y --no-install-recommends ca-certificates curl fontconfig fonts-noto-cjk gnupg tzdata \
    && update-ca-certificates \
    && fc-cache -f \
    && curl -fsSL https://repo.jellyfin.org/ubuntu/jellyfin_team.gpg.key | gpg --dearmor -o /etc/apt/trusted.gpg.d/jellyfin.gpg \
    && echo "deb [arch=amd64] https://repo.jellyfin.org/ubuntu ${CODENAME} main" | tee /etc/apt/sources.list.d/jellyfin.list \
    && amdgpu_package=$(curl -fsSL http://repo.radeon.com/amdgpu-install/latest/ubuntu/${CODENAME} | awk -F '<|>' '/.deb/{print $3}') \
    && curl -fsSL http://repo.radeon.com/amdgpu-install/latest/ubuntu/${CODENAME}/${amdgpu_package} -o /tmp/${amdgpu_package} \
    && dpkg -i /tmp/${amdgpu_package} \
    && apt update \
    && apt install -y --no-install-recommends jellyfin rocm-opencl-runtime \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && apt clean -y \
    && sed -i 's|archive.ubuntu.com|mirrors.bfsu.edu.cn|g' /etc/apt/sources.list \
    && sed -i 's|security.ubuntu.com|mirrors.bfsu.edu.cn|g' /etc/apt/sources.list \
    && sed -i 's|http://|https://|g' /etc/apt/sources.list \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/* /etc/jellyfin
VOLUME ["/cache", "/config"]
WORKDIR /config
ENTRYPOINT ["jellyfin", \
    "--datadir", "/config", \
    "--cachedir", "/cache", \
    "--webdir", "/usr/share/jellyfin/web", \
    "--ffmpeg", "/usr/lib/jellyfin-ffmpeg/ffmpeg"]
