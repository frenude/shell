# 一些用来服务器部署的Shell脚本
## 使用步骤
-   修改`Shell`的权限

```shell
chmod +x "fileName.sh"
```

-   执行脚本

```shell
./"fileName.sh"
```

- 如果执行失败是由于换行符问题

```shell
$ vim "fileName.sh"
$ i
# 告诉 vi 编辑器,使用unix换行符
$ set ff=unix
$ :x
# 查看文件 是否为$结尾
$ cat -A "fileName.sh"
```

### 目录

-   [`docker-install`](shell/docker-install.sh) docker的下载与安装
-   [`docker-install-mysql`](shell/docker-install-mysql.sh)使用docker安装`mysql`
    -   `./docker-install-mysql.sh --help` 查看帮助文档
    -   可选参数
        -   `-u, --user=name `设置数据库用户名 默认为`root`
        -   `-p, --password[=name] `设置用户名为root的密码，默认为`root`
        -   `-P, --port= `设置 `docker`端口与`mysql`端口映射默认为`3306`
        -   `-d, --data=<path>`设置数据文件映射目录
        -   `-v, --version=<number>`设置安装的`mysql`版本号
        -   `-n, --name`设置`docker`镜像名字
    -   **会报个错误`ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)`但是好像没有任何影响 待解决**
-   [`docker-install-redis`](shell/docker-install-redis.sh)使用`docker`安装`redis`
    -   `./docker-install-redis.sh --help` 查看帮助文档
    -   可选参数
        -   `-n, --name`设置`docker`镜像名字
        -   `-p, --password `设置`redis`的密码，默认为`redis`
        -   `-P, --port= `设置 `docker`端口与`redis`端口映射默认为`6379`
        -   `-d, --data=<path>`设置`redis`文件映射目录,其中包含`aof`
        -   `-v, --version=<number>`设置安装的`redis`版本号，默认是`latest`
    -   使用方法
        -   将[`redis.conf`](conf/redis.conf)复制到[`docker-install-redis.sh`](shell/docker-install-redis.sh)相同目录下
        -   然后执行`./docker-install-redis.sh`
    -   **注意：中间涉及alias永久使用的方式**
-   [`java-install.sh`](shell/java-install.sh)下载`openJDK-1.8`
