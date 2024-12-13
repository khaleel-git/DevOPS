Introduction
Docker Overview
why do you need docker -> The matrix from hell
what are containers: isolated env
Docker -> lxc container
Getting started with Docker
Demo - Setup and Install Docker

## Docker Commands
docker run nginx
docker ps
docker ps -a # list running containers
docker stop nginx
docker rm nginx # remove a container
docker images # list available images and sizes
docker rmi nginx # remove images, make sure no container is running using this img
docker pull ngix # only pull and don't run it
docker run ubuntu # run and immediately stopped, containers are not meant to run OS
docker run ubuntu sleep 5 # run a command
docker ps -a
docker exec distracted_mcclimtock cat /etc/hosts
docker run kodekloud/simple-webapp # attached running console
docker run -d kodekloud/simple-webapp # run on detach mode
docker attach a843d # attach again

## Demo - Docker Commands
docker run -it  centos bash
docker ps -a # see all the containers ran before
docker stop nice_mcclintock # kill running containers
docker rm 12f5
docker rmi centos:latest

### execute a command on a running container
docker exec 254f61ab57c5 cat/etc/*release*

## stop all containers at once
docker stop $(docker ps -aq)

# delete all containers at once
docker rm $(docker ps -aq)

## delete all images at once
docker rmi $(docker images -aq)

## Run and name the container
docker run --name webapp nginx:1.14-alpine


## Docke Run
docker run redis:4.0 # tag
default tag is to be latest

by default docker container does not listen to the standard input

docker run -i kodekcloud/simple-prompt-docker # interactive mode, does not ask about input
docker run -it kodecloud/simple-prompt-docker # it zero terminal with interactive mode
docker run -p 38282:8080 --name blue-app -e APP_COLOR=blue kodekloud/simple-webapp

## Port Mapping
docker run -p 80:5000 kodekcloud/webapp
docker run -p 8000:5000 kodekcloud/webapp
docker run -p 3306:3306 mysql
docker run -p 8306:3306 mysql

## Volume Mapping
docker run mysql # /var/lib/mysql # it will be delete upon deleting the container
docker run -v /opt/datadir:/var/lib/mysql mysql # persistent data to mount on file system

## Inspect Container
docker inspect blissful_hopper

## Container Logs
docker logs blissful_hopper

docker run jenkins/jenkins

## Demo - Advanced Docker Run Features


## Docker Images - Create your own image
1. OS - ubuntu
2. Update apt repo
3. Install dependencies using apt
4. Install Python dependencies using pip
5. Copy source code to /opt folder
6. Run the Web server using "flask" command

```Dockerfile
FROM Ubuntu

RUN apt update
RUN apt install python

RUN pip install flask
RUN pip install flask-mysql

COPY . /opt/source-code

ENTRYPOINT FLASK_APP=/opt/source-code/app.py flask run
```
docker build Dockerfile -t khaleel/my-custom-app
docker push khaleel/my-custom-app # docker registry

## Dockerfile
instruction: left cap
argument: right 

every docker image is based on other image
must start from: FROM instructon

COPY: local to remote

entrypoint: run command after building (at the end of building)

layers: from top to bottom

docker history my-img # see all image with layers
cache layers # pre-cache, re-building is faster

## Django deployment on docker
apt-get install python-is-python3

instrcutions:
apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get install python-is-python3 -y
apt-get install python3-pip -y
apt install python3-flask -y
create /opt/app.py
FLASK_APP=app.py flask run --host=0.0.0.0

## Now creating a docker file
```Dockerfile
FROM ubuntu

RUN apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install python-is-python3 -y
RUN apt-get install python3-pip -y
RUN apt install python3-flask -y

COPY app.py /opt/app.py
WORKDIR /opt

ENV FLASK_APP=app.py

ENTRYPOINT ["flask", "run", "--host=0.0.0.0", "--port=8080"]
```

docker build .
docker build . -t my-simple-webapp # quick now, becuase all the layers are cached

## Environment Variables
docker inspect my-container # find a list of env variables


## Commands vs Entrypoint
Containers are not meant to host OS
Containers are meant to host a specific task such as web servers or database servers etc.
Conainers only live as long as the process computation lasts

CMD = command line parameters are replaced
ENTRYPOINT = command line parameters get appended

When using the CMD instruction, it is exactly as if you were executing
`docker run -i -t ubuntu <cmd>`

```Dockerfile
FROM ubuntu

ENTRYPOINT ["sleep"]

CMD ["5"]
```
command at startup: sleep
if no argument passed, default arg is: 5, so command will become: sleep 5

docker run --entrypoint sleep2.0 10 # overrite entrypoint program at startup

```Dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
```
Final command will become: docker-entrypoint.sh apache2-foreground

## Docker Compose
Instructions in yaml files
Runs multiple tasks on a single docker host

Sample application - voting application Stack / Architecture (difference services & development tools)
1. voting-app (web)
2. in-memory-DB (redis)
3. worker (.net)
4. db (postressSQL)
5. result-app (nodeJS)

```shell
docker run -d --name=redis redis
docker run -d --name=db postgres

docker run -d --name=vote -p 5000:80 --link redis:redis voting-app
docker run -d --name=result -p 5001:80 --link db:db result-app

docker run -d --name=worker --link db:db --link redis:redis worker
```
Docker-compose.yml # old format
```yaml
redis:
    image: redis

db:
    image: postgres

vote: 
    image: voting-app # or build: ./vote
    ports:
        - 5000:80
    links:
        - redis

result:
    image: result # or build ./result
    ports:
        - 5000:80
    links:
        - db

worker:
    image: worker # or build ./worker
    links:
        - db
        - redis
```
docker-compose up

Networks property (old, will obsolete)
```yml
version: 2
services:
    redis:
        image: redis
        networks:
            - back-end
    db:
        image: postres
        networks:
            - back-end
    vote:
        image: voting-app
        networks:
            - front-end
            - back-end 
networks:
     front-end:
     back-end:
```
## Project: Example Voting App
link: https://github.com/dockersamples/example-voting-app/tree/main
```shell
git clone https://github.com/dockersamples/example-voting-app.git
cd example-voting-app
# go to voting-app and build it
cd vote
docker build . -t voting-app

docker run --name=redis -d redis # run redis
docker run -p 5000:80 --link redis:redis -d voting-app # link with redis

docker run --name=db -d postgres:15 # run postress

docker build . -t worker-app # build worker
docker run --link redis:redis --link db:db -d worker-app

docker build . -t result-app
docker run -p 5001:80 --link db:db -d result-app
```

## Project: Example Voting App 
### Do the same with Docker Compose
```yml
services:
  vote:
    build: 
      context: ./vote
    ports:
      - "5000:80"

  result:
    build: ./result
    ports:
      - "5001:80"

  worker:
    build:
      context: ./worker

  redis:
    image: redis:alpine

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
```
## Docker Engine
Docker Enginer -> Docker CLI, REST API, Docker Deamon
Docker Deamon: Background process that manages docker objects such as images, containers, volumes and networks (brain of docker)
REST API: interface, talk to other services, provide instructions
Docker CLI: command line interface (could be available on a remote host) # docker -H=remote-docker-engne:2375, docker -H=10.123.1.1:2375 run nginx

### Namespace:
1. Process ID - PID # pid 1 (root), pid: 2, 3, 4 (child)
2. Unix Timesharing
3. Network
4. Mount
5. InterProcess

cgroups:
all containers share the same cpu and memory
limit each container to consume

docker run --cpus=.5 ubuntu
docker run --memory=100m ubuntu

### Docker Storage & File systems
/var/lib/docker -> aufs, containers, image, volumes 
`tree /var/lib/docker`

#### Layered architecture (Image Layers)
each line in the run command is separate layer
each layer only store the changes and have diff sizes

building on the same image, docker can use cache and do the job faster and consme less disk space # re-uses all the previous layers and do the job faster and consume less disk space


Container Layer: writable layer, on top of image layers (read-only)
Container Layer is (w,r) both
Copy on write: on the container layer
Stop Container: all the data would be deleted

#### Volumes
```shell
/var/lib/docker -> volumes/data_volume # persistent storage
docker volume create data_volume # optional
docker run -v data_volume:/var/lib/mysql mysql # mount the data volume into var/lib/mysql, stores on the volume, its persistent

# if dont create the volume and uses below, docker will automatically create the data_volume and mount it
docker run -v data_volume2:/var/lib/mysql mysql

# if data is alread present on a diff dir
docker run -v /data/mysql:/var/lib/mysql mysql # bind mounting

1. volume mounting
2. bind mounting

# storage driver, to enable storage architecture such as: AUFS, ZFS, BTRFS, Device Mapper, Overlay, Overlay2
docker run \
--mount type=bind,source=/data/mysql,target=/var/lib/mysql mysql
# Aufs -> ubuntu, docker will use the best storage driver automatically based on OS
```

### Networking
1. Bridge - commonly used
2. None
3. Host

#### Bridge Network
internal ips: 172.17.0.2, 172.17.0.3, ....
to access the app, map it to host port
`docker run ubuntu`


#### Host
no port mappping required
can't run multiple containers
docker run ubuntu --network=host

#### None
no network
isolated network
`docker run ubuntu --network=none`

### Embedded DNS
dns server: 127.0.0.11 fixed
mysql.connect (mysql) # only use container name to connect other container running the same node

```shell
# attach a none network to container
docker run --name alpine-2 --network=none alpine

docker network ls
docker network inspect bridge

# create a bridge network
docker network create -d bridge wp-mysql-network --subnet 182.18.0.0/24 --gateway 182.18.0.1

# attach newly created bridge network to container
docker run --name mysql --network=wp-mysql-network -e MYSQL_ROOT_PASSWORD=db_pass123 mysql:5.6

# longest docker command
docker run --name webapp -p 38080:8080 --link mysql-db:mysql-db -e DB_Host=mysql-db -e DB_Password=db_pass123 --network=wp-mysql-network kodekloud/simple-webapp-mysql
```
## Docker Registry
```shell
docker run -d -p 5000:5000 --name registry registry:2
docker image tag my-image localhost:5000/my-image

docker push lochalhost:5000/my-image

docker pull localhost:5000/my-image
docker pull 192.168.56.100:5000/my-image


docker image prune -a  # remove all dangling images locally
# WARNING! This will remove all images without at least one container associated to them.
```

## Container Orchestration
DockerSwarmp
Kubernetes

### DockerSwarm
docker service create --replicas=1000 nodejs
lacks advanced features

Swarm Manager
Workers (many)

```shell
docker service create --replicas=3 my-web-server
docker service create --replicas=3 -p 8080:80 my-web-server
```

### kubernetes
support for many different vendors
```yml
kubectl rolling-update my-web-server --rollback

kubectl rolling-update my-web-server --image=web-server:2

kubectl scale --replicas=2000 my-web-server

kubectl run --replicas=1000 my-web-server
```
#### Components of Kubernetes
Contoller
Scheduler
API Serve
etcd
kubelet (agent)
Container Runtime

#### kubectl
```shell
kubectl run hello-minikube
kubectl cluster-info
kubectl get nodes
kubectl run my-web-app --image=my-we-app --replicas=100
```



## Resources:
https://codewithyury.com/docker-run-vs-cmd-vs-entrypoint/