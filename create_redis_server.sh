#!/bin/bash

# 레디스 클러스터를 생성할 포트 리스트 파라미터
PORTS=("$@")

if [ ${#PORTS[@]} -lt 3 ]; then
    echo "Error: At least 3 ports are required."
    exit 1
fi

mkdir -p logs

mkdir -p nodes

# 구성 파일 생성
create_config_file() {
    local port=$1
    local config_file="redis_cluster_$port.conf"

    echo "port $port" >> $config_file
    echo "" >> $config_file
    echo "bind 0.0.0.0" >> $config_file
    echo "" >> $config_file
    echo "daemonize yes" >> $config_file
    echo "" >> $config_file
    echo "cluster-enabled yes" >> $config_file
    echo "" >> $config_file
    echo "cluster-node-timeout 3000" >> $config_file
    echo "" >> $config_file
    echo "cluster-config-file nodes/nodes-$port.conf" >> $config_file
    echo "" >> $config_file
    echo "logfile logs/redis_$port.conf" >> $config_file

    echo "Created Redis config file: $config_file"
}

# 각 포트별로 구성 파일 생성 및 실행
for port in "${PORTS[@]}"
do
    echo "Creating Redis node on port $port"
    create_config_file $port
done
