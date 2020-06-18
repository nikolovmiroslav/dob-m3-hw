#!/bin/bash

echo "* Swarm Init manager 192.168.89.100 ..."
sudo docker swarm init --listen-addr 192.168.89.100 --advertise-addr 192.168.89.100
echo "* Swarm Join manager ..."
sudo docker swarm join-token -q worker > /swarm/worker.token