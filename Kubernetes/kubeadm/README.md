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

# disable
sudo ufw disable
sudo systemctl disable ufw
sudo systemctl stop ufw

# remove all rules
sudo ufw reset

# Flush all iptables rules
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT
sudo iptables -P OUTPUT ACCEPT

# Step 4: Save iptables Rules
# To make sure the flush persists after a reboot, save the empty rules:
sudo iptables-save | sudo tee /etc/iptables/rules.v4
sudo ip6tables-save | sudo tee /etc/iptables/rules.v6

# restart kubelet
sudo systemctl restart kubelet
sudo systemctl status kubelet

```

#### Worker nodes joining
```shell
# disable swap first
sudo swapoff -a # temp disable
sudo sed -i '/swap/d' /etc/fstab # completely remove at start

vi /etc/sysctl.conf # add below 3 lines in this file for all nodes
net.bridge.bridge-nf-call-iptables = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward = 1

# run below 3 lines for active session
sudo sysctl -w net.bridge.bridge-nf-call-iptables=1
sudo sysctl -w net.bridge.bridge-nf-call-ip6tables=1
sudo sysctl -w net.ipv4.ip_forward=1

sudo sysctl --system # restart it

# reset kubeadm if already joined
sudo kubeadm reset -f
sudo rm -rf /var/lib/kubelet /etc/kubernetes

# Just make the modification on the file /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true --fail-swap-on=false"

# then execute commands:
systemctl daemon-reload
sudo systemctl restart kubelet
sudo systemctl status kubelet

# finally join worker node to master node
sudo kubeadm join 192.168.80.10:6443 --token utac4e.b4ew3s2mmxvucblc \
        --discovery-token-ca-cert-hash sha256:7c5ccdca8e84d7a5397c0b536006a3f1f4e41b6f491d1b316f7dbc900328d07d
```
