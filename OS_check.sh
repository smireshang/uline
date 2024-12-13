#!/bin/bash

# 获取操作系统信息
if [ -f /etc/os-release ]; then
    source /etc/os-release

    # 判断是 Debian 还是 Ubuntu
    if [[ "$ID" == "debian" ]]; then
        echo "This is a Debian-based system."
        echo "Version: $VERSION"
    elif [[ "$ID" == "ubuntu" ]]; then
        echo "This is an Ubuntu-based system."
        echo "Version: $VERSION"
    else
        echo "This is a different $NAME system."
        echo "Version: $VERSION"
    fi
elif [ -f /etc/freebsd-version ]; then
    echo "This is a FreeBSD system."
    cat /etc/freebsd-version
else
    echo "Unknown system."
fi

# 获取内核版本
echo "Kernel Version:"
uname -r
