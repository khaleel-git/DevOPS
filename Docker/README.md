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
