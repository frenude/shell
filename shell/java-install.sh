#!/bin/sh

# 下载wget
yum install -y wget
# 切换目录
cd /usr/local/
# 下载JDK github lfs 上传的包
wget https://media.githubusercontent.com/media/frenude/shell/main/package/jdk-8u281-linux-x64.rpm
# 云OSS 国内速度较快
wget https://frenude.oss-cn-beijing.aliyuncs.com/package/jdk-8u281-linux-x64.rpm
# 安装 jdk-8u281-linux-x64.rpm
rpm -ivh jdk-8u281-linux-x64.rpm
