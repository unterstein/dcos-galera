#!/bin/bash

cd $(dirname $0)

docker push unterstein/dcos-galera:latest
