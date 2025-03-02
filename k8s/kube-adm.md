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
##### Flannel prequisite CNI
subnet: 10.244.0.0/16 used by flannel CNI on master & worker nodes

#### To Start using kubeadm, do the following
```shell
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

#### Flannel CNI Setup
```shell
sudo modprobe br_netfilter # load modules

vi /etc/sysctl.conf # add below 3 lines in this file for all nodes
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1

# run below 3 lines for active session
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sudo sysctl -w net.ipv4.ip_forward=1

sudo sysctl --system # restart it

# finally apply flannel config - only for master
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

#### Worker nodes joining
```shell
vi /etc/sysctl.conf # add below 3 lines in this file for all nodes
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1

# run below 3 lines for active session
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sudo sysctl -w net.ipv4.ip_forward=1

sudo sysctl --system # restart it

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab  # Prevent swap from enabling on reboot

# finally join worker node to master node
sudo kubeadm join 192.168.80.10:6443 --token 4fqvwv.0rjlt8i39g91ls1o --discovery-token-ca-cert-hash sha256:9b443e9bd44c031183434903ef32c2e0790f645e826858bb9bd0f5c962d5daed
```
