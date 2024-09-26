# Docker
docker --help
docker search nginx
docker pull nginx
docker pull ubuntu/ngnix
image tag: label of the container
docker pull ngnix:1.22.1
dokcer images
dockdr rmi ubuntu/nginx
docker rmi ngnix:1.22.1 # delete older version

create and run containers:
docker run ngnix 
docker run --detach --publish 8080:80 --name mywebserver ngnix nginx# accessible to the outside world, computer to container 
docker ps # list containers running
docker ps -a # list all containers runnding and stopped
docker start container_id
docker stop docker_name

```bash
GET /
nc localhost 8080
ctrl + D # exit netcat session
```

docker run vs docker start # run configure, docker start does not build anything
docker ps --all
docker rm docker_name # rmi removes images, rm remove containers
docker rmi nginx # remove this image, wont' work, because first we have to remove container,
stop container # docker stop mywebserver
docker rm mywebserver # remove container
docker rmi nginx

docker run --detach --publish 8080:80 --name mywebserver nginx # dont auto restart
docker run --detach --publish 8080:80 --name mywebserver nginx --restart always

# Docker file
```bash
FROM nginx
COPY index.html /usr/share/ngnix/html/index.html
```
docker build --tag jeremy/customnginx:1.0 myimage 
