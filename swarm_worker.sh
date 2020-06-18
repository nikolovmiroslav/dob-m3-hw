#!/bin/bash

echo "* Swarm Join worker1 192.168.89.101 ..."
sudo docker swarm join --token $(cat /swarm/worker.token) --advertise-addr 192.168.89.101 192.168.89.100