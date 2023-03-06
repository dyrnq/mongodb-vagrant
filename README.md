# mongodb-vagrant

This is an experiment on mongodb.

## usage

### start vm

```bash
vagrant up vm214
vagrant up vm215
vagrant up vm216
```

## start mongo

```bash
## login vm214 vm215 vm216 and exec bash /vagrant/scripts/install-mongodb.sh use root
vagrant ssh vm214
[vagrant@vm214 ~]$ su --login root
[root@vm214 ~]# bash /vagrant/scripts/install-mongodb.sh
```

```bash
## login vm216 and exec bash /vagrant/scripts/init-mongodb.sh use root
[vagrant@vm216 ~]$ su --login root
[root@vm216 ~]# bash /vagrant/scripts/init-mongodb.sh
```


## root user

```bash
## login vm216 and exec only
[vagrant@vm216 ~]$ su --login root
[vagrant@vm216 ~]$ bash /vagrant/scripts/init-user.sh
```

## web ui

```bash
docker run -d \
--restart always \
--name me \
-e ME_CONFIG_MONGODB_SERVER=192.168.55.214,192.168.55.215,192.168.55.216 \
-e ME_CONFIG_MONGODB_PORT=27017 \
-e ME_CONFIG_BASICAUTH_USERNAME="" \
-e ME_CONFIG_MONGODB_ENABLE_ADMIN=true \
-e ME_CONFIG_MONGODB_AUTH_USERNAME=root \
-e ME_CONFIG_MONGODB_AUTH_PASSWORD=root \
-p 8081:8081 mongo-express:latest


# docker rm -f adminer
# docker run -d \
# --name=adminer \
# --restart always \
# -p 8080:8080 \
# adminer:4.8.1


docker run -it --rm \
-p 4321:4321 \
-e MONGO_URL=mongodb://root:root@192.168.55.214:27017 \
ugleiton/mongo-gui:latest
```

## help

```bash
docker run mongo:6.0.4-jammy --help
Options:
  --networkMessageCompressors arg (=snappy,zstd,zlib)
                                        Comma-separated list of compressors to 
                                        use for network messages

General options:
  -h [ --help ]                         Show this usage information
  --version                             Show version information
  -f [ --config ] arg                   Configuration file specifying 
                                        additional options
  --configExpand arg                    Process expansion directives in config 
                                        file (none, exec, rest)
  --port arg                            Specify port number - 27017 by default
  --ipv6                                Enable IPv6 support (disabled by 
                                        default)
  --listenBacklog arg (=4096)           Set socket listen backlog size
  --maxConns arg (=1000000)             Max number of simultaneous connections
  --pidfilepath arg                     Full path to pidfile (if not set, no 
                                        pidfile is created)
  --timeZoneInfo arg                    Full path to time zone info directory, 
                                        e.g. /usr/share/zoneinfo
  --nounixsocket                        Disable listening on unix sockets
  --unixSocketPrefix arg                Alternative directory for UNIX domain 
                                        sockets (defaults to /tmp)
  --filePermissions arg                 Permissions to set on UNIX domain 
                                        socket file - 0700 by default
  --fork                                Fork server process
  -v [ --verbose ] [=arg(=v)]           Be more verbose (include multiple times
                                        for more verbosity e.g. -vvvvv)
  --quiet                               Quieter output
  --logpath arg                         Log file to send write to instead of 
                                        stdout - has to be a file, not 
                                        directory
  --syslog                              Log to system's syslog facility instead
                                        of file or stdout
  --syslogFacility arg                  syslog facility used for mongodb syslog
                                        message
  --logappend                           Append to logpath instead of 
                                        over-writing
  --logRotate arg                       Set the log rotation behavior 
                                        (rename|reopen)
  --timeStampFormat arg                 Desired format for timestamps in log 
                                        messages. One of iso8601-utc or 
                                        iso8601-local
  --setParameter arg                    Set a configurable parameter
  --bind_ip arg                         Comma separated list of ip addresses to
                                        listen on - localhost by default
  --bind_ip_all                         Bind to all ip addresses
  --noauth                              Run without security
  --transitionToAuth                    For rolling access control upgrade. 
                                        Attempt to authenticate over outgoing 
                                        connections and proceed regardless of 
                                        success. Accept incoming connections 
                                        with or without authentication.
  --slowms arg (=100)                   Value of slow for profile and console 
                                        log
  --slowOpSampleRate arg (=1)           Fraction of slow ops to include in the 
                                        profile and console log
  --profileFilter arg                   Query predicate to control which 
                                        operations are logged and profiled
  --auth                                Run with security
  --clusterIpSourceAllowlist arg        Network CIDR specification of permitted
                                        origin for `__system` access
  --profile arg                         0=off 1=slow, 2=all
  --cpu                                 Periodically show cpu and iowait 
                                        utilization
  --sysinfo                             Print some diagnostic system 
                                        information
  --noscripting                         Disable scripting engine
  --notablescan                         Do not allow table scans
  --shutdown                            Kill a running server (for init 
                                        scripts)
  --keyFile arg                         Private key for cluster authentication
  --clusterAuthMode arg                 Authentication mode used for cluster 
                                        authentication. Alternatives are 
                                        (keyFile|sendKeyFile|sendX509|x509)

Replication options:
  --oplogSize arg                       Size to use (in MB) for replication op 
                                        log. default is 5% of disk space (i.e. 
                                        large is good)

Replica set options:
  --replSet arg                         arg is <setname>[/<optionalseedhostlist
                                        >]
  --enableMajorityReadConcern [=arg(=1)] (=1)
                                        Enables majority readConcern. 
                                        enableMajorityReadConcern=false is no 
                                        longer supported

Serverless mode:
  --serverless arg                      Serverless mode implies replication is 
                                        enabled, cannot be used with replSet or
                                        replSetName.

Sharding options:
  --configsvr                           Declare this is a config db of a 
                                        cluster; default port 27019; default 
                                        dir /data/configdb
  --shardsvr                            Declare this is a shard db of a 
                                        cluster; default port 27018

Storage options:
  --storageEngine arg                   What storage engine to use - defaults 
                                        to wiredTiger if no data files present
  --dbpath arg                          Directory for datafiles - defaults to 
                                        /data/db
  --directoryperdb                      Each database will be stored in a 
                                        separate directory
  --syncdelay arg (=60)                 Seconds between disk syncs
  --journalCommitInterval arg (=100)    how often to group/batch commit (ms)
  --upgrade                             Upgrade db if needed
  --repair                              Run repair on all dbs
  --restore                             This should only be used when restoring
                                        from a backup. Mongod will behave 
                                        differently by handling collections 
                                        with missing data files, allowing 
                                        database renames, skipping oplog 
                                        entries for collections not restored 
                                        and more.
  --journal                             Enable journaling
  --nojournal                           Disable journaling (journaling is on by
                                        default for 64 bit)
  --oplogMinRetentionHours arg (=0)     Minimum number of hours to preserve in 
                                        the oplog. Default is 0 (turned off). 
                                        Fractions are allowed (e.g. 1.5 hours)

Free Monitoring Options:
  --enableFreeMonitoring arg            Enable Cloud Free Monitoring 
                                        (on|runtime|off)
  --freeMonitoringTag arg               Cloud Free Monitoring Tags

WiredTiger options:
  --wiredTigerCacheSizeGB arg           Maximum amount of memory to allocate 
                                        for cache; Defaults to 1/2 of physical 
                                        RAM
  --zstdDefaultCompressionLevel arg (=6)
                                        Default compression level for zstandard
                                        compressor
  --wiredTigerJournalCompressor arg (=snappy)
                                        Use a compressor for log records 
                                        [none|snappy|zlib|zstd]
  --wiredTigerDirectoryForIndexes       Put indexes and data in different 
                                        directories
  --wiredTigerCollectionBlockCompressor arg (=snappy)
                                        Block compression algorithm for 
                                        collection data [none|snappy|zlib|zstd]
  --wiredTigerIndexPrefixCompression arg (=1)
                                        Use prefix compression on row-store 
                                        leaf pages

AWS IAM Options:
  --awsIamSessionToken arg              AWS Session Token for temporary 
                                        credentials

TLS Options:
  --tlsOnNormalPorts                    Use TLS on configured ports
  --tlsMode arg                         Set the TLS operation mode 
                                        (disabled|allowTLS|preferTLS|requireTLS
                                        )
  --tlsCertificateKeyFile arg           Certificate and key file for TLS
  --tlsCertificateKeyFilePassword arg   Password to unlock key in the TLS 
                                        certificate key file
  --tlsClusterFile arg                  Key file for internal TLS 
                                        authentication
  --tlsClusterPassword arg              Internal authentication key file 
                                        password
  --tlsCAFile arg                       Certificate Authority file for TLS
  --tlsClusterCAFile arg                CA used for verifying remotes during 
                                        inbound connections
  --tlsCRLFile arg                      Certificate Revocation List file for 
                                        TLS
  --tlsDisabledProtocols arg            Comma separated list of TLS protocols 
                                        to disable [TLS1_0,TLS1_1,TLS1_2,TLS1_3
                                        ]
  --tlsAllowConnectionsWithoutCertificates 
                                        Allow client to connect without 
                                        presenting a certificate
  --tlsAllowInvalidHostnames            Allow server certificates to provide 
                                        non-matching hostnames
  --tlsAllowInvalidCertificates         Allow connections to servers with 
                                        invalid certificates
  --tlsLogVersions arg                  Comma separated list of TLS protocols 
                                        to log on connect [TLS1_0,TLS1_1,TLS1_2
                                        ,TLS1_3]

ls -l /usr/bin/ | grep mongo
-rwxr-xr-x. 1 root root   140506008 Dec 19  2013 mongod
-rwxr-xr-x. 1 1000   1000  15828424 Mar  1 14:40 mongodump
-rwxr-xr-x. 1 1000   1000  15522960 Mar  1 14:40 mongoexport
-rwxr-xr-x. 1 1000   1000  16383648 Mar  1 14:40 mongofiles
-rwxr-xr-x. 1 1000   1000  15784248 Mar  1 14:40 mongoimport
-rwxr-xr-x. 1 1000   1000  16160976 Mar  1 14:40 mongorestore
-rwxr-xr-x. 1 root root   101961688 Dec 19  2013 mongos
-rwxr-xr-x. 1 1000   1000  97206776 Feb 28 14:13 mongosh
-rwxr-xr-x. 1 1000   1000  15385656 Mar  1 14:40 mongostat
-rwxr-xr-x. 1 1000   1000  14957432 Mar  1 14:40 mongotop

cat /etc/passwd |grep mongo
mongodb:x:999:999::/data/db:/bin/sh

echo $HOME
/data/db

```

## ref

- [https://mp.weixin.qq.com/s/JwM7rsp0HxqsZddpxpQrhg](https://mp.weixin.qq.com/s/JwM7rsp0HxqsZddpxpQrhg)
- [https://hub.docker.com/_/mongo/](https://hub.docker.com/_/mongo/)
- [eugenechen0514/demo_mongo_cluster](https://github.com/eugenechen0514/demo_mongo_cluster)
- [Deploy a production-mongodb cluster](https://medium.com/@hoannt.it/deploy-a-production-mongodb-cluster-1e4097032321)
- [MongoDB](http://devgou.com/article/MongoDB/)
- [MongoDB 分片集群技术](https://www.cnblogs.com/clsn/p/8214345.html)
- [Configuration File Settings and Command-Line Options Mapping](https://www.mongodb.com/docs/manual/reference/configuration-file-settings-command-line-options-mapping/#std-label-conf-file-command-line-mapping)
- [Dockerfile](https://github.com/docker-library/mongo/blob/master/6.0/Dockerfile)
