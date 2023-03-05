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
test -f /vagrant/mongo.tar && docker load < /vagrant/mongo.tar

# openssl rand -base64 756
# https://www.mongodb.com/docs/manual/tutorial/deploy-replica-set-with-keyfile-access-control/
cat >/opt/mongodb-keyfile<<EOF
h/yAXaq6iWWV0z1A+9NdaxviBD+nMsdyg8jTuaYwK9qyDJYv91Qw7GGevT1CsPzz
8glsPPnN4UZilDfq5CszyJWqBiLUSFbHbp4mL/PxIzCNZQwIT04IOgU5z1k4pPOd
ySSQDas6dDgZ6kLbUhE69en3IQdF0iWvltAJYBgqhyfVZoVy2U/0pBFSJLTX/Jyq
mVQRgLoj8Xg6yffa6fFjkchTD/zphxGlgF0eLFG96xfb6Pgy8Q/gsx+F4aKwxPMq
MTmo7OoKs4GdPcTbSM9M9pQmT2NFyQF4zRDea1p4FG3bTEPFeFhea9+x9q+441TK
n6NuJ8AN6rJVsQ3tIIcyUvZX0boWHiEFovd5/Poq9x+lQxE9tYN8ZS7GQWuDSjSX
KFrdnyqQ0s1HQn9VqKbNgz3Blz3VEUekcDWVV1JDi+ZoMVTtGDB4a/DJksTzb/Lx
DYkdm1o6f73VIprPbtamEdOTfISTx6yAlMd+Zd5ibjxBtVvOa6i/Ma8MmZvoz7TP
93AUXt4QG765eJrPvOI++kTBaswGGml09VvIavIQl078+4IyqBOwu0Ulfzec7e2h
QfO13/u2mJMFQWqAf2qn0mOFO2HbXMMHWujTufW5Z3pe0LtpEgNBBRcSZFHuJo8n
rK5rVUjCIMdPhFHmqVv0R3pYY0Zh35aL3FB+f51G/mkw5aoi+4DZm2GtllIAbadu
ZQ5dna3JwHen/Yren5C3c7GPdxeIt3jZKqOQ3f0cdm8MiOFeaH0iuo4/JXlhEUL2
rU9zFYbzlrCF3OSWHj+QIuCu0NOQLBnE7P3ARLVJtAoW3NlgL4DYFEilwLEWmeYp
lNcyrkvoOCOPweAYy5Da1TZT9wLyqwitGn/aV+OSF4la2kIxFxg59zDowA7WpKoq
rFY1L/tF8bTaRSmx7Z8Y/0hbX2nbTRosuWG1LwRHm5zGCwDEwfOr5h4dRcwSMv8F
P0RsPASHX6AuVZPw79hg2VOA6w999Df7ctkzlYG8e2Ye8an8
EOF


cat >/opt/mongod.yml<<EOF
security:
  keyFile: /opt/mongodb-keyfile
EOF

cat >/opt/mongos.yml<<EOF
security:
  keyFile: /opt/mongodb-keyfile
EOF

chmod 400 /opt/mongodb-keyfile
chown 999:999 /opt/mongodb-keyfile
chown 999:999 /opt/mongod.yml
chown 999:999 /opt/mongos.yml

docker run -d \
--restart always \
--name mc -p 27019:27019 \
-v /opt/mongodb-keyfile:/opt/mongodb-keyfile \
-v /opt/mongod.yml:/opt/mongod.yml \
"${image}" \
--configsvr --replSet config --bind_ip 0.0.0.0 --port 27019 --config /opt/mongod.yml

docker run -d \
--restart always \
--name ms1 -p 27111:27111 \
-v /opt/mongodb-keyfile:/opt/mongodb-keyfile \
-v /opt/mongod.yml:/opt/mongod.yml \
"${image}" \
--shardsvr --replSet s1 --bind_ip 0.0.0.0 --port 27111 --config /opt/mongod.yml

docker run -d \
--restart always \
--name ms2 -p 27112:27112 \
-v /opt/mongodb-keyfile:/opt/mongodb-keyfile \
-v /opt/mongod.yml:/opt/mongod.yml \
"${image}" \
--shardsvr --replSet s2 --bind_ip 0.0.0.0 --port 27112 --config /opt/mongod.yml


docker run -d \
--restart always \
--name mr -p 27017:27017 \
-v /opt/mongodb-keyfile:/opt/mongodb-keyfile \
-v /opt/mongos.yml:/opt/mongos.yml \
"${image}" \
mongos --bind_ip 0.0.0.0 \
--configdb config/192.168.55.214:27019,192.168.55.215:27019,192.168.55.216:27019 --config /opt/mongos.yml

}

fun_install


