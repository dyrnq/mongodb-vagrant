#!/usr/bin/env bash

set -Eeo pipefail


docker exec -i mc mongosh --port 27019 <<EOF
rs.initiate(
  {
    _id : "config",
    configsvr: true,
    members: [
      { _id: 0, host: "192.168.55.214:27019" },
      { _id: 1, host: "192.168.55.215:27019" },
      { _id: 2, host: "192.168.55.216:27019" }
    ]
  }
)
EOF
sleep 10s;

docker exec -i ms1 mongosh --port 27111 <<EOF
rs.initiate(
  {
    _id : "s1",
    members: [
      { _id: 0, host: "192.168.55.214:27111" },
      { _id: 1, host: "192.168.55.215:27111" },
      { _id: 2, host: "192.168.55.216:27111" }
    ]
  }
)
EOF


sleep 10s;

docker exec -i ms2 mongosh --port 27112 <<EOF
rs.initiate(
  {
    _id : "s2",
    members: [
      { _id: 0, host: "192.168.55.214:27112" },
      { _id: 1, host: "192.168.55.215:27112" },
      { _id: 2, host: "192.168.55.216:27112" }
    ]
  }
)
EOF



sleep 10s;


docker exec -i mc mongosh --port 27019 <<< "rs.status()"
docker exec -i ms1 mongosh --port 27111 <<< "rs.status()"
docker exec -i ms2 mongosh --port 27112 <<< "rs.status()"

sleep 10s;

docker exec -i mr mongosh <<EOF
sh.addShard("s1/192.168.55.214:27111,192.168.55.215:27111,192.168.55.216:27111")
sh.addShard("s2/192.168.55.214:27112,192.168.55.215:27112,192.168.55.216:27112")
EOF