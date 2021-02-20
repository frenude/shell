#!/bin/sh

# 帮助信息
if [[ $1 = "--help" ]] || [[ $1 = "-h" ]] || [[ $1 = "-?" ]]
then
    echo "Usage: docker-install-redis [OPTIONS]"
    echo "   -?, --help                       Display this help and exit."
    echo "   -h, --help                       Synonym for -?"
    echo "   -n, --name                       The name of the Docker container default (redis)."
    echo "   -p, --password[=name]            Password to set redis login default (redis)."
    echo "   -P, --port=                      Docker start local port and redis /etc/redis.conf
                                              The mapping of port in conf is (6379) by default."
    echo "   -d, --data=<path>                Mapping of redis data Default, /docker/redis/data configuration
                                              in the server is mapped to the /redis/data configuration in docker."
    echo "   -v, --version=<number>           Specify the version number of redis pulled by docker default (latest)."
else

    # 说明
    show_usage="args: [-n , -p , -P , -d , -v ] [--name=, --password=, --port=, --data=, --version=]"

    # 默认值声明
    opt_name="redis"

    opt_password="redis"

    opt_port="6379"

    opt_data="/docker/redis"

    opt_version="latest"

    opt_workdir=$(cd $(dirname $0); pwd)

    # 创建redis.conf的目录文件夹
    mkdir -p "$opt_data"
    mv "$opt_workdir/redis.conf" "$opt_data/redis.conf"

    GETOPT_ARGS=`getopt -o n:p:P:d:v: -al name:,password:,port:,data:,version: -- "$@"`
    eval set -- "$GETOPT_ARGS"

    #获取参数
    while [ -n "$1" ]
    do
            case "$1" in
                    -n|--name) opt_name=$2; shift 2;;
                    -p|--passwd) opt_password=$2; shift 2;;
                    -P|--port) opt_port=$2; shift 2;;
                    -d|--data) opt_data=$2; shift 2;;
                    -v|--version) opt_version=$2; shift 2;;
                    --) break ;;
                    *) echo $1,$2,$show_usage; break ;;
            esac
    done

    if [[ -z $opt_name || -z $opt_password || -z $opt_port  || -z $opt_data|| -z $opt_version ]]; then
        echo $show_usage
        echo "opt_name: $opt_name , opt_password: $opt_password , opt_port: $opt_port ,opt_data: $opt_data ,opt_version: $opt_version"
        exit 0
    fi

    docker pull "redis:$opt_version"

    docker run -d -p "$opt_port":6379 -v "$opt_data/redis.conf:/etc/redis/redis.conf" -v "$opt_data/snapshot:/var/lib/redis" -v "$opt_data/data:/data" -v "$opt_data/logs/redis.log:/var/log/redis/redis.log" --name "$opt_name" "redis:$opt_version" redis-server  /etc/redis/redis.conf --appendonly yes  --requirepass "$opt_password"

    # 设置永久alias
    # 不安全写法
    opt_alias="docker exec -it $opt_name redis-cli -h 127.0.0.1 -p $opt_port -a $opt_password"
    # 安全写法 密码内部验证
    # opt_alias="docker exec -it $opt_name redis-cli -h 127.0.0.1 -p $opt_port"
    # "
    echo "alias redis-cli='$opt_alias'"  >> ~/.bashrc
    # 这个的目的是让每次打开终端自动source ~/.bashrc 如果写入过一次就可以注释掉了
    # echo "source ~/.bashrc" >> ~/.bash_profile


fi
