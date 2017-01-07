# Running MariaDB Galera cluster on top of DC/OS

## Overview
**Current Version:** 10.1.20

### About DC/OS
We will run Galera Cluster on top of DC/OS, the datacenter operating system, which is a production proven platform to run microservices, as well as your traditional databases, big data and fast data applications.
DC/OS is build on top of Apache Mesos, which Twitter uses for example to run their production on or Apple uses to run Siri. Mesos abstracts that you are dealing a cluster and make it feel like you would interact with a single computer.

### About MariaDB Galera Cluster (from mariadb.com)
MariaDB Galera Cluster is a synchronous multi-master cluster for MariaDB. It is available on Linux only, and only supports the XtraDB/InnoDB storage engines.

Starting with MariaDB 10.1, the wsrep API for Galera Cluster is included by default.

Please visit the [MariaDB Galera Cluster documentation](https://mariadb.com/kb/en/mariadb/what-is-mariadb-galera-cluster/) to get more information about the cluster features.

## Install MariaDB Galera Cluster on your DC/OS cluster
It`s that simple! Just execute the following command in your terminal:

```
dcos marathon app add marathon-galera.json
```

If you do not want to use the CLI, just copy the content of `marathon-galera.json` to the DC/OS UI in the service section.

## Marathon configuration
You are dealing with only one marathon application definition. Therefore the first node listed as A-Record in DC/OS DNS will initialize a new cluster and all the other nodes will wait a few seconds and join the newly created cluster. The idea how to bundle the containers together is from [here](https://www.digitalocean.com/community/tutorials/how-to-configure-a-galera-cluster-with-mariadb-10-1-on-ubuntu-16-04-servers)

## Scaling
Just go to DC/OS UI in the service section and scale your nodes to the needed amount. The newly started MariaDB containers will automatically join the cluster.

## Persistence
Note: You are using local persistent volumes. The big advantage of using local persistent volume vs ephemeral volumes or remote volumes is:


- If a MariaDB Galera Cluster node failes, a fresh instance will be restarted on the same machine again and the replacement instance becomes the same data like the failed one.
- Therefore Galera can decide if it wants to reuse the data or if the data will be invalidated.
- Galera clustering has build in replication, therefore there is no need for an remote volume.
- You don`t have remote writes, because this volume is on your local disk.

## Docker images
### Base image
This implementation based on the [official docker-mariadb image](https://github.com/docker-library/mariadb/tree/master/10.1.20) from [docker hub](https://hub.docker.com/r/library/mariadb/tags/) and has only few adaptions to add service discovery within the DC/OS cluster using DNS and the decision making which of the initial nodes is the initializing node.

### Networking
The MariaDB Galera Cluster is running inside an overlay network, where each container will receive an own IP address and exposes all ports within this overlay network. This overlay network and the resulting IP addresses are only available within the DC/OS cluster. [More about DC/OS networking](https://docs.mesosphere.com/1.8/usage/service-discovery/dns-overview/)

### Adaptions
The main part of the adaptions to run the official docker-mariadb image on top of DC/OS are related to service discovery, see the [entrypoint of the mariadb cluster image](https://github.com/unterstein/dcos-galera/blob/master/image/dcos-galera.sh).
