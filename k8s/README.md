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
#### Install ETCD
    - Download Binaries
    - Extract
    - Run ETCD Service
#### Operate ETCD
    - Run ETCD Service: `./etcd'
    - ./etcdctl set key1 value1
    - ./etcdctl get key1
    - Port: 2379
    - ./etcdctl --version -> utitlity version & API version
#### ETCD in kubernetes
    - Everything below is changed in etcd server
    - Nodes, Pods, Configs, Secrets, Accounts, Roles, Bindings, Others
    - Setup: `wget -q --https-only "download_link.tar.gz"
    - Setup - Kubeadm: `kubectl get pods -n kube-system && kubectl exec etcd-master -n kube-system etcdctl get / --prefix -keys-only` (Run insid the etcd-master POD)
    - ETCD in HA (High Availability) Environment, there are multiple etcd servers
#### ETCD Commands
    ```shell
    # version 2
    etcdctl backup
    etcdctl cluster-health
    etcdctl mk
    etcdctl mkdir
    etcdctl set

    # version 3
    etcdctl snapshot save
    etcdctl endpoint health
    etcdctl get
    etcdctl put

    # export etcdctl api of version 3
    export ETCDCTL_API=3

    # etcd certificates
    --cacert /etc/kubernetes/pki/etcd/ca.crt
    --cert /etc/kubernetes/pki/etcd/server.crt
    --key /etc/kubernetes/pki/etcd/server.key

    # final command
    kubectl exec etcd-controlplane -n kube-system -- sh -c "ETCDCTL_API=3 etcdctl get / --prefix --keys-only --limit=10 --cacert /etc/kubernetes/pki/etcd/ca.crt --cert /etc/kubernetes/pki/etcd/server.crt --key /etc/kubernetes/pki/etcd/server.key"
    ```
### kube-scheduler

### Controller-Manager:
#### node-controller
#### Replication - Controller

### Kube-apiserver
primary management component in k8s
```shell
# Creating of pod via post request
curl -X POST /api/v1/namespaces/default/pods ...[other]

# Creating of pod with kubectl command
kubectl create pod name
```
#### Kube-Api Server does the following:
    1. Auth user
    2. Validate request
    3. Retrieve data
    4. Update ETCD
    5. Scheduler

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


