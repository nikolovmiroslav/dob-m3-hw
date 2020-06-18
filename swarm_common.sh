#!/bin/bash

echo "192.168.89.100 manager.dob.lab manager" | sudo tee -a /etc/hosts
echo "192.168.89.101 worker1.dob.lab worker1" | sudo tee -a /etc/hosts

sudo ufw allow 22/tcp
sudo ufw allow 2376/tcp
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

sudo ufw allow 8080/tcp
sudo ufw allow 3306/tcp

sudo ufw reload


sudo firewall-cmd --add-port=22/tcp --permanent
sudo firewall-cmd --add-port=2376/tcp --permanent
sudo firewall-cmd --add-port=2377/tcp --permanent
sudo firewall-cmd --add-port=7946/tcp --permanent
sudo firewall-cmd --add-port=7946/udp --permanent
sudo firewall-cmd --add-port=4789/udp --permanent

sudo firewall-cmd --add-port=8080/tcp --permanent
sudo firewall-cmd --add-port=3306/tcp --permanent

sudo firewall-cmd --reload

# sudo apt-get purge ufw -y
# sudo apt-get purge firewalld -y
# sudo apt-get purge iptables-persistent -y 

sudo systemctl restart docker