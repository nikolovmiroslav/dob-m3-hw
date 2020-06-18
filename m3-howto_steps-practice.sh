# 1. Download docker-machine and docker clinet
https://download.docker.com/components/engine/windows-server/19.03/docker-19.03.5.zip 
https://github.com/docker/machine/releases/download/v0.16.2/docker-machine-Windows-x86_64.exe 
Place both in one folred and provide this folder in system environment Path 

# 2. Create default docker-machine
docker-machine create --virtualbox-no-vtx-check  --driver virtualbox default

--virtualbox-no-vtx-check # suppress -> Error with pre-create check: "This computer doesn't have VT-X/AMD-v enabled. Enabling it in the BIOS is mandatory"


# 3. Start Docker machine
docker-machine ls
NAME      ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
default   -        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.5

docker-machine env default
SET DOCKER_TLS_VERIFY=1
SET DOCKER_HOST=tcp://192.168.99.100:2376
SET DOCKER_CERT_PATH=C:\Users\m.nikolov\.docker\machine\machines\default
SET DOCKER_MACHINE_NAME=default
SET COMPOSE_CONVERT_WINDOWS_PATHS=true
REM Run this command to configure your shell:
REM     @FOR /f "tokens=*" %i IN ('docker-machine env default') DO @%i

D:\Education\Development\DevOps\Basic\3\hw>@FOR /f "tokens=*" %i IN ('docker-machine env default') DO @%i

# Print the host of started machine
echo %DOCKER_HOST%
tcp://192.168.99.100:2376

# The machine is already printed in verison
docker version
Client: Docker Engine - Enterprise
 Version:           19.03.5
 API version:       1.40
 Go version:        go1.12.12
 Git commit:        2ee0c57608
 Built:             11/13/2019 08:00:16
 OS/Arch:           windows/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          19.03.5
  API version:      1.40 (minimum version 1.12)
  Go version:       go1.12.12
  Git commit:       633a0ea838
  Built:            Wed Nov 13 07:28:45 2019
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          v1.2.10
  GitCommit:        b34a5c8af56e510852c35414db4c1f4fa6172339
 runc:
  Version:          1.0.0-rc8+dev
  GitCommit:        3e425f80a8c931f88e6d94a8c831b9d5aa481657
 docker-init:
  Version:          0.18.0
  GitCommit:        fec3683

# 4. SSH to the machine
docker-machine ssh default
   ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

docker@default:~$ docker version







# Install Docker Compose

#sudo curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/1.26.0/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose
chmod +x /tmp/docker-compose
sudo cp /tmp/docker-compose /usr/local/bin/docker-compose

ip a
192.168.99.107

scp -r M3-2b/ docker@192.168.99.107:/home/docker/
pswd: tcuser


docker-compose build
docker-compose up -d
docker-compose down


docker-compose logs
docker-compose ps
docker-compose restart com-mysql
docker-compose config
docker-compose exec com-php /bin/bash


# docker swarm
docker-machine stop default
docker-machine create -d virtualbox --virtualbox-no-vtx-check docker-1
docker-machine create -d virtualbox --virtualbox-no-vtx-check docker-2
docker-machine create -d virtualbox --virtualbox-no-vtx-check docker-3

docker-machine ls
NAME       ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
default    -        virtualbox   Stopped                                       Unknown
docker-1   -        virtualbox   Running   tcp://192.168.99.104:2376           v19.03.5
docker-2   -        virtualbox   Running   tcp://192.168.99.105:2376           v19.03.5
docker-3   -        virtualbox   Running   tcp://192.168.99.106:2376           v19.03.5

docker-machine ssh docker1
docker swarm init
docker swarm init --advertise-addr 192.168.99.104
docker swarm join-token -q worker
SWMTKN-1-4awkenbrqdnr2cltgu1lgjeyl8g40bitenih5jwh4gpiswltrc-8695khwryc5d6cn644tj0iybu
exit

docker-machine ssh docker2
docker swarm join --token SWMTKN-1-4awkenbrqdnr2cltgu1lgjeyl8g40bitenih5jwh4gpiswltrc-8695khwryc5d6cn644tj0iybu --advertise-addr 192.168.99.105 192.168.99.104
This node joined a swarm as a worker.
exit

docker-machine ssh docker3
docker swarm join --token SWMTKN-1-4awkenbrqdnr2cltgu1lgjeyl8g40bitenih5jwh4gpiswltrc-8695khwryc5d6cn644tj0iybu --advertise-addr 192.168.99.106 192.168.99.104
This node joined a swarm as a worker.
exit

docker-machine ssh docker-1
docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
t7nvjb49tv2pkuwnf5rag14px *   docker-1            Ready               Active              Leader              19.03.5
eagefye4n3y2cj7xfhvubre0c     docker-2            Ready               Active                                  19.03.5
0x6tizauxyiby5see74os6kki     docker-3            Ready               Active                                  19.03.5

docker service create --replicas 1 --name pinger alpine ping tuionui.com
# differnt ways to insepct the service
docker service ls
docker node ps
docker service ps pinger
docker service inspect pinger
docker service inspect --pretty pinger

# scaling the service tasks
docker service scale pinger=3
docker service ps pinger
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
aa60oyitwj9c        pinger.1            alpine:latest       docker-1            Running             Running 7 minutes ago
bvsx0l13xgts        pinger.2            alpine:latest       docker-3            Running             Running 48 seconds ago
vcg7jmlkg48m        pinger.3            alpine:latest       docker-2            Running             Running 53 seconds ago

docker service scale pinger=7
docker service ps pinger
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
aa60oyitwj9c        pinger.1            alpine:latest       docker-1            Running             Running 7 minutes ago
bvsx0l13xgts        pinger.2            alpine:latest       docker-3            Running             Running about a minute ago
vcg7jmlkg48m        pinger.3            alpine:latest       docker-2            Running             Running about a minute ago
y70nafwqlp1q        pinger.4            alpine:latest       docker-3            Running             Running 19 seconds ago
m82gmf2bwxa4        pinger.5            alpine:latest       docker-1            Running             Running 19 seconds ago
vzpdqob1rn18        pinger.6            alpine:latest       docker-2            Running             Running 19 seconds ago
pcdtrhagz5cd        pinger.7            alpine:latest       docker-2            Running             Running 19 seconds ago

# Drain before stop node
docker node update --availability drain docker-2
docker service ps pinger
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
aa60oyitwj9c        pinger.1            alpine:latest       docker-1            Running             Running 9 minutes ago
bvsx0l13xgts        pinger.2            alpine:latest       docker-3            Running             Running 3 minutes ago
76a39ikjs3ov        pinger.3            alpine:latest       docker-3            Running             Running 7 seconds ago
vcg7jmlkg48m         \_ pinger.3        alpine:latest       docker-2            Shutdown            Shutdown 8 seconds ago
y70nafwqlp1q        pinger.4            alpine:latest       docker-3            Running             Running about a minute ago
m82gmf2bwxa4        pinger.5            alpine:latest       docker-1            Running             Running about a minute ago
6oyb82nx7cfc        pinger.6            alpine:latest       docker-3            Running             Running 7 seconds ago
vzpdqob1rn18         \_ pinger.6        alpine:latest       docker-2            Shutdown            Shutdown 8 seconds ago
wg2xfch65l9n        pinger.7            alpine:latest       docker-1            Running             Running 7 seconds ago
pcdtrhagz5cd         \_ pinger.7        alpine:latest       docker-2            Shutdown            Shutdown 8 seconds ago

docker node inspect --pretty docker-2
ID:                     eagefye4n3y2cj7xfhvubre0c
Hostname:               docker-2
Joined at:              2020-06-01 14:52:39.515174963 +0000 utc
Status:
 State:                 Ready
 Availability:          Drain
 Address:               192.168.99.105
 
docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
t7nvjb49tv2pkuwnf5rag14px *   docker-1            Ready               Active              Leader              19.03.5
eagefye4n3y2cj7xfhvubre0c     docker-2            Ready               Drain                                   19.03.5
0x6tizauxyiby5see74os6kki     docker-3            Ready               Active                                  19.03.5


 # Return back to active
docker node update --availability active docker-2
docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
t7nvjb49tv2pkuwnf5rag14px *   docker-1            Ready               Active              Leader              19.03.5
eagefye4n3y2cj7xfhvubre0c     docker-2            Ready               Active                                  19.03.5
0x6tizauxyiby5see74os6kki     docker-3            Ready               Active                                  19.03.5

# But docker-2 is still in shutdown
docker service ps pinger
ID                  NAME                IMAGE               NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
aa60oyitwj9c        pinger.1            alpine:latest       docker-1            Running             Running 13 minutes ago
bvsx0l13xgts        pinger.2            alpine:latest       docker-3            Running             Running 7 minutes ago
76a39ikjs3ov        pinger.3            alpine:latest       docker-3            Running             Running 4 minutes ago
vcg7jmlkg48m         \_ pinger.3        alpine:latest       docker-2            Shutdown            Shutdown 4 minutes ago
y70nafwqlp1q        pinger.4            alpine:latest       docker-3            Running             Running 5 minutes ago
m82gmf2bwxa4        pinger.5            alpine:latest       docker-1            Running             Running 5 minutes ago
6oyb82nx7cfc        pinger.6            alpine:latest       docker-3            Running             Running 4 minutes ago
vzpdqob1rn18         \_ pinger.6        alpine:latest       docker-2            Shutdown            Shutdown 4 minutes ago
wg2xfch65l9n        pinger.7            alpine:latest       docker-1            Running             Running 4 minutes ago
pcdtrhagz5cd         \_ pinger.7        alpine:latest       docker-2            Shutdown            Shutdown 4 minutes ago
 
# return back task to docker-2
docker service update --force pinger # but this is not fine it leads to interuption from stop/start of services
# Next options will guarantee that there will be interruption of service
--update-delay duration     Delay between updates (ns|us|ms|s|m|h)
--update-parallelism uint   Maximum number of tasks updated simultaneously (0 to update all at once)
docker service ps pinger

#cleanup
docker service rm pinger # automatic cleanup all containers
pinger
docker service ps pinger
no such service: pinger
docker container ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
docker container ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES


# Create Stack or group of services
scp -r M3-3/ docker@192.168.99.104:/home/docker/
scp -r M3-3/ docker@192.168.99.105:/home/docker/
scp -r M3-3/ docker@192.168.99.106:/home/docker/
pwd:tcuser

docker-machine ssh docker-1
cd M3-3
cat docker-compose.yml
docker stack deploy -c docker-compose.yml  docker-help
Creating network docker-help_swrm-network
Creating service docker-help_swrm-php
Creating service docker-help_swrm-mysql

docker stack ls
NAME                SERVICES            ORCHESTRATOR
docker-help         2                   Swarm
docker@docker-1:~/M3-3$ docker stack ps docker-help
ID                  NAME                           IMAGE                           NODE                DESIRED STATE       CURRENT STATE                ERROR                              PORTS
y40tgdia2kyw        docker-help_swrm-mysql.1       shekeriev/dob-w3-mysql:latest   docker-1            Running             Running about a minute ago
r1tgljkn7uk5         \_ docker-help_swrm-mysql.1   shekeriev/dob-w3-mysql:latest   docker-1            Shutdown            Rejected 2 minutes ago       "No such image: shekeriev/dob-…"
rndsieh9n2if        docker-help_swrm-php.1         shekeriev/dob-w3-php:latest     docker-3            Running             Running 2 minutes ago
8gefr97ojtrx        docker-help_swrm-php.2         shekeriev/dob-w3-php:latest     docker-2            Running             Running 2 minutes ago
x14fdftkjki5         \_ docker-help_swrm-php.2     shekeriev/dob-w3-php:latest     docker-2            Shutdown            Failed 2 minutes ago         "starting container failed: OC…"
5fpf67efak1m        docker-help_swrm-php.3         shekeriev/dob-w3-php:latest     docker-3            Running             Running 2 minutes ago
te7foxhk1ae5        docker-help_swrm-php.4         shekeriev/dob-w3-php:latest     docker-1            Running             Running 2 minutes ago
xjhxqmz42k3o        docker-help_swrm-php.5         shekeriev/dob-w3-php:latest     docker-2            Running             Running 2 minutes ago


# Scale the front-end
docker service scale docker-help_swrm-php=7
docker service ls
docker network ls

docker stack rm docker-help
docker service ls
docker network ls

exit
docker-machine rm default docker-1 docker-2 docker-3


