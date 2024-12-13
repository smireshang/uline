#!/bin/bash

# 设置颜色
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RESET='\033[0m'  # 重置颜色

# 打印标题
echo -e "${BLUE}==============================${RESET}"
echo -e "${GREEN}系统信息检测${RESET}"
echo -e "${BLUE}==============================${RESET}"

# 获取操作系统信息
if [ -f /etc/os-release ]; then
    source /etc/os-release

    echo -e "\n${YELLOW}操作系统信息:${RESET}"

    # 判断是 Debian 还是 Ubuntu
    if [[ "$ID" == "debian" ]]; then
        echo -e "类型: ${GREEN}Debian${RESET}"
        echo -e "版本: ${GREEN}$VERSION${RESET}"
    elif [[ "$ID" == "ubuntu" ]]; then
        echo -e "类型: ${GREEN}Ubuntu${RESET}"
        echo -e "版本: ${GREEN}$VERSION${RESET}"
    else
        echo -e "类型: ${GREEN}$NAME${RESET}"
        echo -e "版本: ${GREEN}$VERSION${RESET}"
    fi
elif [ -f /etc/freebsd-version ]; then
    echo -e "\n${YELLOW}操作系统信息:${RESET}"
    echo -e "类型: ${GREEN}FreeBSD${RESET}"
    cat /etc/freebsd-version
else
    echo -e "\n${YELLOW}操作系统信息:${RESET}"
    echo -e "未知系统"
fi

# 获取内核版本
echo -e "\n${YELLOW}内核版本:${RESET}"
KERNEL=$(uname -r)
echo -e "内核版本: ${GREEN}$KERNEL${RESET}"

# 获取内存信息
echo -e "\n${YELLOW}内存信息:${RESET}"
TOTAL_MEMORY=$(free -h | awk '/^Mem:/ {print $2}')
USED_MEMORY=$(free -h | awk '/^Mem:/ {print $3}')
FREE_MEMORY=$(free -h | awk '/^Mem:/ {print $4}')
echo -e "总内存: ${GREEN}$TOTAL_MEMORY${RESET}"
echo -e "已用内存: ${GREEN}$USED_MEMORY${RESET}"
echo -e "空闲内存: ${GREEN}$FREE_MEMORY${RESET}"

# 获取Swap信息
echo -e "\n${YELLOW}Swap信息:${RESET}"
TOTAL_SWAP=$(free -h | awk '/^Swap:/ {print $2}')
USED_SWAP=$(free -h | awk '/^Swap:/ {print $3}')
FREE_SWAP=$(free -h | awk '/^Swap:/ {print $4}')
echo -e "总Swap: ${GREEN}$TOTAL_SWAP${RESET}"
echo -e "已用Swap: ${GREEN}$USED_SWAP${RESET}"
echo -e "空闲Swap: ${GREEN}$FREE_SWAP${RESET}"

# 获取硬盘信息，排除docker挂载
echo -e "\n${YELLOW}硬盘信息:${RESET}"
# 排除docker挂载目录 /var/lib/docker
DISK_INFO=$(df -h --exclude-type=tmpfs --exclude-type=devtmpfs | grep -v '/var/lib/docker' | grep -E '^/dev|/mnt|/data' | awk '{print $1, $2, $3, $4}')
while read -r LINE; do
    DEVICE=$(echo $LINE | awk '{print $1}')
    TOTAL=$(echo $LINE | awk '{print $2}')
    USED=$(echo $LINE | awk '{print $3}')
    FREE=$(echo $LINE | awk '{print $4}')
    echo -e "设备: ${GREEN}$DEVICE${RESET}"
    echo -e "总空间: ${GREEN}$TOTAL${RESET}"
    echo -e "已用空间: ${GREEN}$USED${RESET}"
    echo -e "空闲空间: ${GREEN}$FREE${RESET}"
done <<< "$DISK_INFO"

# 获取系统运行时长
echo -e "\n${YELLOW}系统运行时长:${RESET}"
UPTIME=$(uptime -p)
echo -e "系统运行时长: ${GREEN}$UPTIME${RESET}"

# 打印结束
echo -e "\n${BLUE}==============================${RESET}"
