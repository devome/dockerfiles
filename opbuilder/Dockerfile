FROM ubuntu
ARG DEBIAN_FRONTEND=noninteractive
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    SHELL=/bin/bash \
    LANG=C.UTF-8 \
    PS1="\u@\h:\w \$ " \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    USERNAME=evine
RUN echo "change repo..." \
    && sed -i 's/archive.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/security.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list \
    && sed -i 's/ports.ubuntu.com/mirrors.bfsu.edu.cn/g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y \
       # 额外装的包
       autojump \
       bsdmainutils \
       ca-certificates \
       coreutils \
       fzf \
       htop \
       jq \
       moreutils \
       openssh-client \
       openssl \
       perl \
       sudo \
       tzdata \
       zsh \
       # 编译需要的包
       ack \
       antlr3 \
       aria2 \
       asciidoc \
       autoconf \
       automake \
       autopoint \
       binutils \
       bison \
       build-essential \
       bzip2 \
       ccache \
       cmake \
       cpio \
       curl \
       device-tree-compiler \
       fastjar \
       flex \
       gawk \
       gettext \
       gcc-multilib \
       g++-multilib \
       git \
       gperf \
       haveged \
       help2man \
       intltool \
       libc6-dev-i386 \
       libelf-dev \
       libglib2.0-dev \
       libgmp3-dev \
       libltdl-dev \
       libmpc-dev \
       libmpfr-dev \
       libncurses5-dev \
       libncursesw5-dev \
       libpython3-dev \
       libreadline-dev \
       libssl-dev \
       libtool \
       lrzsz \
       mkisofs \
       msmtp \
       nano \
       ninja-build \
       p7zip \
       p7zip-full \
       patch \
       pkgconf \
       python2.7 \
       python3 \
       python3-pyelftools \
       qemu-utils \
       rsync \
       scons \
       squashfs-tools \
       subversion \
       swig \
       texinfo \
       uglifyjs \
       upx-ucl \
       unzip \
       vim \
       wget \
       xmlto \
       xxd \
       zlib1g-dev \
    && if [ ! -f /usr/bin/python ]; then cd /usr/bin; ln -s python3 python; fi \
    && ln -sf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo "$TZ" > /etc/timezone \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && update-ca-certificates \
    && useradd $USERNAME -u $PUID -U -m -d /home/$USERNAME -s /usr/bin/zsh \
    && apt-get clean -y \
    && rm -rf \
       /tmp/* \
       /var/lib/apt/lists/* \
       /var/tmp/*
COPY entrypoint.sh /usr/bin/entrypoint.sh
USER $USERNAME
WORKDIR /home/$USERNAME
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
