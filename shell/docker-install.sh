#!/bin/sh
# 卸载旧版本
sudo yum remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine

# 安装 Docker Engine-Community 依赖
sudo yum install -y yum-utils device-mapper-persistent-data lvm2

# 使用官方源地址
# sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 使用阿里云镜像源
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# 安装 Docker Engine-Community
sudo yum install -y docker-ce docker-ce-cli containerd.io



# 设置国内镜像源
echo "
{
 "registry-mirrors": ["https://registry.docker-cn.com"]
}
" >> /etc/docker/daemon.json
# 启动 Docker。
sudo systemctl start docker

# 通过运行 hello-world 映像来验证是否正确安装了 Docker Engine-Community 。
sudo docker run hello-world


