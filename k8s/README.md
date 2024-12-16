# CKA Certification Course - Certified Kubernetes Administrator
 - CKA prepration: https://learn.kodekloud.com/user/courses/cka-certification-course-certified-kubernetes-administrator
 - CKA Certification link: https://www.cncf.io/certification/cka/

## Core Concepts Section Introduction
## Cluster Architecture

## Master Node
1. etcd cluster
2. kube-scheduler
3. Controller-Manager (node-controller, Replication-Controller)
4. kube-apiserver

## Worker Node
1. kubelet
2. kube-proxy

### ETCD cluster
ETCD is a distributed reliable key-value store that is simple, secure & fast
#### key-value store:
    - Relational databases vs NoSQL: key-value is NoSQL
    - key-value documents
    - Json or Yaml
#### install ETCD
    - Download Binaries
    - Extract
    - Run ETCD Service
#### Operate ETCD
    - Run ETCD Service: `./etcd'
    - ./etcdctl set key1 value1
    - ./etcdctl get key1
    - Port: 2379



### kube-scheduler

### Controller-Manager:
#### node-controller
#### Replication - Controller

### Kube-apiserver
orchestrating all operations within the server
primary component

## Worker Node
### kubelet (captain of the ship)
listens for instructions from kube-apiserver
manages containers

### kube-proxy
communication, traffic rules

## Docker-vs-ContainerD
Docker: dominant due to user-experience
docker + kubernetes (initially) -> only work with docker
CRI: Container Runtime Interface - OCI Standard (open container initiative -> imagespec, runtimespec) -> anyone can build container runtime

### docker:
Docker doesn't comply with CRI
rkt: supported by CRI
dockershim: temporary way to contiue to support docker for runtime
v1.24: support for docker removed
now docker followed the imagespec
now docker comply with CRI

### ContainerD:
conainerd: CRI compatible
runtime on its own
can work with kubernetes
it is a member of cncf
containerd alone can be used if dont needed docker other functions
CLI - ctr: ctr comes with containerD, not very user friendly, only supports limited features
```shell
ctr
ctr images pull docker.io/library/redis:alpine
ctr run pull docker.io/library/redis:alpine
```
#### ctr utility (containerD):
Only used for de-bugging purposes
dont use it
limited features
not recommended

#### CLI nerdctl (containerD):
provdes a coker-lie cli for containerD
nerdctl supports docker compose
nerdctl supports newest features in containerd
 - Encrypted container images
 - Lazy Pulling
 - P2P image distribution
 - Image signing and verifying
 - Namespaces in kubernetes
```shell
nerdctl
nerdctl run --name redis redis:alpine
nerdctl run --name webserver -p 80:80 -d nginx
```

#### rkt
CRI (container runtime interface)
crictl utility, maintained by k8s community
must be installed separately
debugging tool - special debugging purposes
kubectl is unaware of circtl type of images
```shell
crictl
crictl pull busybox
crictl images
crictl ps -a
crictl exec -i -t 34234345dsfsjklfj ls
crictl logs 3e03423425f1
crictl pods
```

## A note on Docker Deprecation
Why are we still talking about docker if docker is deprecated?
cli, api, build, volumes, auth, security

containerD was removed from docker
docker is still the most popular container solution
**--> k8s no longer require docker as the runtime**
it is ok to use docker as an example

**--> Replace: docker - nerdctl
