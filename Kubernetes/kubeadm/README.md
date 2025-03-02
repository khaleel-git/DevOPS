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