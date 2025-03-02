## Kubeadm Setup
1. master node
2. worker node 1
3. worker node 2

## Installing kubeadm
[Installing kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/)

## Setting up the Cluster
[Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)

### Container Runtime
[Container Runtime](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd)

#### install containerd on all nodes (master,workers)
`sudo apt install containerd` # using containerd as a container runtime

#### create a directory 
```shell
sudo mkdir -p /etc/containerd
sudo vi /etc/containerd/config.toml
containerd config default # copy paste default toml configuration file by running
```

#### use systemd cgoup:
`containerd config default | sed 's/SystemdCgroup = false/SystemdCgroup = true/' | sudo tee /etc/conainerd/config.toml`

#### Check SystemdCgroup as true & restart it
```shell
cat /etc/containerd/config.toml | grep -i SystemdCgroup
cat /etc/containerd/config.toml | grep -i SystemdCgroup -B 55
sudo systemctl restart containerd
```

#### Kubeadm init
```shell
sudo kubeadm init --apiserver-advertise-address 192.168.80.10 --pod-network-cidr "10.244.0.0/16" --upload-certs
```
##### Flannel CNI
subnet: 10.244.0.0/16 used by flannel CNI on master & worker nodes

#### To Start using kubeadm, do the following
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


```