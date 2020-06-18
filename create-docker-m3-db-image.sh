vi Dockerfile


FROM ubuntu:18.04
LABEL maintainer="SoftUni @nikolov.miroslav m3 mysql docker image"

#echo "* Install mariadb-server ..."
RUN apt-get update -y
RUN apt-get install -y mariadb-server

#echo "* Start HTTP ..."
RUN systemctl enable mariadb
RUN systemctl start mariadb

# echo "* Firewall - open port 3306 ..."
RUN firewall-cmd --add-port=3306/tcp --permanent
RUN firewall-cmd --reload

EXPOSE 3306

# echo "* Create and load the database ..."
#RUN mysql -u root < /db/db_setup.sql



$docker image build -t mysql .



$ssh-keyscan 192.168.89.100
$ssh-keyscan 192.168.89.100 >> C:\Users\m.nikolov\.ssh\known_hosts

$docker context create --default-stack-orchestrator=swarm --docker "host=ssh://vagrant@192.168.89.100,skip-tls-verify=true" m3-manager
$docker context ls
$docker context use m3-manager
#set DOCKER_HOST=ssh://vagrant@192.168.89.100




# 1. Create mysql image
$docker image pull ubuntu:18.04
$docker image ls
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
ubuntu              18.04               c3c304cb4f22        6 weeks ago         64.2MB

$docker container run -it --name m3-mysql ubuntu:18.04




# 2. Create nginx-php-image
# Crete folder nginx-php-image with the files from https://www.howtoforge.com/tutorial/how-to-create-docker-images-with-dockerfile-18-04/
$scp -r nginx-php-image/ docker@192.168.99.107:/home/docker/

$cd nginx-php-image
$chmod +x start.sh
$docker build -t nginx-php-image .
$docker image ls

$mkdir -p /webroot
$sudo chown -R docker:docker /webroot

docker run -d -v /webroot:/var/www/html -p 8080:80 --name test-container nginx-php-image

# test nginx
$echo '<h1>Nginx and PHP-FPM 7.2 inside Docker Container with Ubuntu 18.04 Base Image</h1>' > /webroot/index.html

$docker@default:~/nginx-php-image$ curl localhost:8080
<h1>Nginx and PHP-FPM 7.2 inside Docker Container with Ubuntu 18.04 Base Image</h1>

# test php
$echo '<?php phpinfo(); ?>' > /webroot/info.php

docker@default:~/nginx-php-image$ curl localhost:8080/info.php

# test from host
# VirtualBox - on the machine add port forwarding http/TCP/8088/8088
http://localhost:8088/
http://localhost:8088/info.php


# Publish in hub.docker.com
create new repository with the name as the image: nginx-php-image
$docker login
777383

$docker tag nginx-php-image:latest 777383/nginx-php-image:0.1
$docker push 777383/nginx-php-image:0.1

$docker tag nginx-php-image:latest 777383/nginx-php-image:latest
$docker push 777383/nginx-php-image:latest


# 3. docker-compose.yml

version: "3"

services:
    dob-m3-hw-nginx-php:
        image: 777383/nginx-php-image:0.1
        deploy:
          replicas: 3
        ports:
            - 8080:80
        volumes:
            - "/web:/var/www/html:ro"
        networks:
            - dob-m3-hw-network
        depends_on:
            - dob-m3-hw-mysql

    dob-m3-hw-mysql:
        image: mysql:5.7
        volumes:
            - "/db:/docker-entrypoint-initdb.d:ro"
        networks:
            - dob-m3-hw-network

networks:
    dob-m3-hw-network:


# 4.
$vagrant up

$scp docker-compose.yml vagrant@192.168.89.100:/home/vagrant/

$vagrant ssh manager

$cat docker-compose.yml

$docker stack deploy -c docker-compose.yml m3-hw

$docker stack ps m3-hw

