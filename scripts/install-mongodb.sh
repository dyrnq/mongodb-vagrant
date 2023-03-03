#!/usr/bin/env bash

set -Eeo pipefail
image=${image:-mongo:6.0.4-jammy}
while [ $# -gt 0 ]; do
    case "$1" in
        --image)
            image="$2"
            shift
            ;;
        --*)
            echo "Illegal option $1"
            ;;
    esac
    shift $(( $# > 0 ? 1 : 0 ))
done


fun_install(){
docker run -d \
--restart always \
--name mc -p 27019:27019 \
"${image}" \
--configsvr --replSet config --bind_ip 0.0.0.0 --port 27019

docker run -d \
--restart always \
--name ms1 -p 27111:27111 \
"${image}" \
--shardsvr --replSet s1 --bind_ip 0.0.0.0 --port 27111

docker run -d \
--restart always \
--name ms2 -p 27112:27112 \
"${image}" \
--shardsvr --replSet s2 --bind_ip 0.0.0.0 --port 27112


docker run -d \
--restart always \
--name mr -p 27017:27017 \
"${image}" \
mongos --bind_ip 0.0.0.0 \
--configdb config/192.168.55.214:27019,192.168.55.215:27019,192.168.55.216:27019

}

fun_install


