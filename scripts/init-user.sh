#!/usr/bin/env bash

# https://www.mongodb.com/docs/v6.0/core/security-users/#sharded-cluster-users
# https://www.mongodb.com/docs/manual/tutorial/configure-scram-client-authentication/
# Create the user administrator
docker exec -i mr mongosh <<EOF
use admin
db.createUser(
  {
    user: "root",
    pwd: "root",
    roles: [
      { role: "root", db: "admin" }
    ]
  }
)
EOF

# docker exec -i mr mongosh <<EOF
# use admin
# db.createUser(
#   {
#     user: "root",
#     pwd: "root",
#     roles: [
#       { role: "userAdminAnyDatabase", db: "admin" },
#       { role: "readWriteAnyDatabase", db: "admin" }
#     ]
#   }
# )
# EOF