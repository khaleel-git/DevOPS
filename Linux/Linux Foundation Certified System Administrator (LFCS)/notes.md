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
