#!/bin/sh

# 帮助信息
if [[ $1 = "--help" ]] || [[ $1 = "-h" ]] || [[ $1 = "-?" ]]
then
    echo "Usage: docker-install-mysql [OPTIONS]"
    echo "    -?, --help                     Display this help and exit."
    echo "    -h, --help                     Synonym for -?"
    echo "    -u, --user=name                User for set mysql login default root."
    echo "    -n, --name                     The name of the Docker container."
    echo "    -p, --password[=name]          Password to set mysql login default root."
    echo "    -P, --port=                    Port number to use for connection or 0 for default to,
                                             As a mapping of $MYSQL_TCP_PORT in my.cnf in docker and mysql
                                             built-in default (3306)."
    echo "    -d, --data=<path>              Mapping of mysql data Default, /var/lib/mysql configuration in the server
                                             is mapped to the /docker/mysql/data configuration in docker."
    echo "    -v, --version=<number>         Specify the version number of mysql pulled by docker default 5.7"
else
   # 说明
show_usage="args: [-u , -p , -P , -d, -v , -n] [--user=, --password=, --port=, --data=, --version= , --name=]"

# 参数
# 用户名
opt_user="root"

# 密码
opt_password="root"

# 端口号
opt_port="3306"

# 数据文件映射目录
opt_data="/docker/mysql"

# 版本号
opt_version="5.7"

# 容器名字
opt_name="mysql"

GETOPT_ARGS=`getopt -o u:p:P:d:v:n: -al user:,password:,port:,data:,version:,name: -- "$@"`
eval set -- "$GETOPT_ARGS"

#获取参数
while [ -n "$1" ]
do
        case "$1" in
                -u|--user) opt_user=$2; shift 2;;
                -p|--passwd) opt_password=$2; shift 2;;
                -P|--port) opt_port=$2; shift 2;;
                -d|--data) opt_data=$2; shift 2;;
                -v|--version) opt_version=$2; shift 2;;
                -n|--name) opt_name=$2; shift 2;;
                --) break ;;
                *) echo $1,$2,$show_usage; break ;;
        esac
done


if [[ -z $opt_user || -z $opt_password || -z $opt_port  || -z $opt_data|| -z $opt_version || -z $opt_name ]]; then
        echo $show_usage
        echo "opt_user: $opt_user , opt_password: $opt_password , opt_port: $opt_port ,opt_data: $opt_data ,opt_version: $opt_version , opt_name: $opt_name"
        exit 0
fi

# 拉取mysql 镜像
docker pull "mysql:$opt_version"

# 删除同名镜像
# docker rm -f "$opt_name"
# 启动镜像
docker run -d -p "$opt_port":3306 --privileged=true -v "$opt_data/db:/var/lib/mysql" -e MYSQL_ROOT_PASSWORD="$opt_password" --name "$opt_name" "mysql:$opt_version" --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci
# -d                                          表示后台运行
# -p                                          表示容器内部端口和服务器端口映射关联
# --privileged=true　                         设值MySQL 的root用户权限, 否则外部不能使用root用户登陆
# -v /docker/mysql/data:/var/lib/mysql　　　　 同上,映射数据库的数据目录, 避免以后docker删除重新运行MySQL容器时数据丢失
# -e MYSQL_ROOT_PASSWORD=　　　　　　　　       设置MySQL数据库root用户的密码
# --name mysql　　　　　　　　　　　　　　　　　　设值容器名称为mysql
# mysql:5.7　　　　　　　　　　　　　　　　　　　 表示从docker镜像mysql:5.7中启动一个容器
# --character-set-server=utf8mb4 --collation-server=utf8mb4_general_ci   设值数据库默认编码
# sudo ln -s /opt/data/mysql/mysqld/mysqld.sock /var/lib/mysql/mysql.sock

# 进入容器

docker exec -i "$opt_name" bash <<EOF

# 进入mysql
mysql -u"$opt_user" -p"$opt_password" <<FOF
# 修改密码并且创建远程访问权限
GRANT ALL PRIVILEGES ON *.* TO '"$opt_user"'@'%' IDENTIFIED BY "$opt_password" WITH GRANT OPTION;
# 更新权限
flush privileges;
FOF
EOF

# 重启mysql
docker restart "$opt_name"
alias mysql="mysql -h 127.0.0.1 -P $opt_port"

fi
