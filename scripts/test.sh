#!/usr/bin/env bash


docker exec -i mr mongosh <<EOF
use admin
db.auth("root","root")

use exampleDB
sh.enableSharding("exampleDB")
db.exampleCollection.ensureIndex( { _id : "hashed" } )
sh.shardCollection( "exampleDB.exampleCollection", { "_id" : "hashed" } )

for (var i = 1; i <= 10; i++) db.exampleCollection.insert(
    {
        "idx": i,
        "sender_id": "3492228440797869",
        "receiver_id": "112404103553895_201007998026838",
        "sender_name": "Agung Hardiawan",
        "message": "Saya ingin menggunakan ini. Tapi tidak bisa menggunakan dengan bahasa Vietnam. Bahasa Indonesia saran saya",
        "attachments": null,
        "created_time": "1599890116000",
        "type": "comment"
    }
)

db.exampleCollection.ensureIndex( { sender_id : "hashed" } )
db.exampleCollection.ensureIndex( { receiver_id : "hashed" } )
db.exampleCollection.find()
//db.dropDatabase()
EOF