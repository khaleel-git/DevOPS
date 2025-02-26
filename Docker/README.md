# Docker Overview

## Introduction
Docker is a platform for developing, shipping, and running applications in isolated environments known as containers. It simplifies the process of managing dependencies and ensures consistency across different computing environments.

## Why Do You Need Docker?
Traditional software deployment is often challenging due to dependency conflicts, OS inconsistencies, and environment mismatches—creating what is known as **"The Matrix from Hell."** Docker solves these issues by encapsulating applications and their dependencies into lightweight, portable containers.

## What Are Containers?
Containers are isolated environments that package applications and their dependencies, ensuring they run uniformly across different systems. Docker utilizes **LXC (Linux Containers)** to achieve containerization.

---

# Getting Started with Docker

## Installation & Setup
To begin using Docker, install it by following the official setup guide: [Docker Installation](https://docs.docker.com/get-docker/).

### Running Your First Container
```shell
docker run nginx
```

---

# Docker Commands

## Basic Commands
```shell
docker ps                # List running containers
docker ps -a             # List all containers
docker stop nginx        # Stop a container
docker rm nginx          # Remove a container
docker images            # List available images
docker rmi nginx         # Remove an image
docker pull nginx        # Pull an image without running it
docker run ubuntu        # Run an Ubuntu container
```

## Running Commands in Containers
```shell
docker exec distracted_mcclimtock cat /etc/hosts
docker run -it centos bash  # Interactive terminal access
```

## Managing Containers
```shell
docker stop $(docker ps -aq)   # Stop all containers
docker rm $(docker ps -aq)     # Remove all containers
docker rmi $(docker images -aq)  # Remove all images
```

## Naming and Running Containers
```shell
docker run --name webapp nginx:1.14-alpine
```

## Port Mapping
```shell
docker run -p 8080:80 nginx
```

## Volume Mapping (Persistent Data)
```shell
docker run -v /opt/datadir:/var/lib/mysql mysql
```

---

# Creating Custom Docker Images

## Writing a Dockerfile
```dockerfile
FROM ubuntu

RUN apt update && apt install -y python3 python3-pip
RUN pip install flask flask-mysql

COPY . /opt/source-code

ENTRYPOINT ["flask", "run", "--host=0.0.0.0", "--port=8080"]
```

### Build & Push Custom Image
```shell
docker build -t khaleel/my-custom-app .
docker push khaleel/my-custom-app
```

---

# Environment Variables
```shell
docker inspect my-container  # View environment variables of a container
```

---

# Docker Compose

## Example `docker-compose.yml`
```yaml
version: '3'
services:
  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: "postgres"
      POSTGRES_PASSWORD: "postgres"
  redis:
    image: redis:alpine
  vote:
    build: ./vote
    ports:
      - "5000:80"
  result:
    build: ./result
    ports:
      - "5001:80"
  worker:
    build: ./worker
```

### Run Services
```shell
docker-compose up --build
```

---

# Docker Networking

## Network Types
1. **Bridge** (default, internal networking)
2. **Host** (direct access to host network)
3. **None** (completely isolated)

## Creating a Custom Network
```shell
docker network create -d bridge custom-network
```

---

# Docker Registry

## Running a Local Registry
```shell
docker run -d -p 5000:5000 --name registry registry:2
```

## Pushing & Pulling Images
```shell
docker tag my-image localhost:5000/my-image
docker push localhost:5000/my-image
docker pull localhost:5000/my-image
```

---

# Container Orchestration

## Docker Swarm
```shell
docker service create --replicas=3 -p 8080:80 my-web-server
```

## Kubernetes
```yaml
kubectl run my-web-app --image=my-web-app --replicas=100
```

### Kubernetes Components
- **Controller**
- **Scheduler**
- **API Server**
- **etcd**
- **kubelet** (Agent)
- **Container Runtime**

---

# Resources
- [Docker Documentation](https://docs.docker.com/)
- [Docker vs CMD vs Entrypoint](https://codewithyury.com/docker-run-vs-cmd-vs-entrypoint/)