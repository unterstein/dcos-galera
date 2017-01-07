#!/bin/bash

cd $(dirname $0)

version="latest"
if [ -n "$1" ]; then
	version=$1
fi

docker push unterstein/dcos-galera:$version
