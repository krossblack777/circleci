#!/bin/sh
set -xe

if [ -e $HOME/cache/centos.tar ] && $(md5sum --status --quiet --check $HOME/cache/dockerfile.digest)
then
  docker load < $HOME/cache/centos.tar
else
  mkdir -p $HOME/cache
  docker build -t docker/centos .
  md5sum Dockerfile  > $HOME/cache/dockerfile.digest
  docker save docker/centos > $HOME/cache/centos-sshd.tar
fi

docker info
