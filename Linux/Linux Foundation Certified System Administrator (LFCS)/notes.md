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

---
Manage and Configure Virtual Machines
QEMU-KVM # quick emulator, kernel based virtual machines
virsh # manage virtual machines from the command line

sudo apt install virt-manager # normally linux which has a graphical interface but can be used with command line as well

vi testmachine.xml # hvm: hardvare virtual machine
```xml
<domain type="qemu">
    <name>TestMachine</name>
    <memory unit="GiB">1</memory>
    <vcpu>1</vcpu>
    <os>    
        <type arch="x86_64">hvm</type>
    </os>
<domain>
```
virsh define testmachine.xml
virsh help
virsh list
virsh list -all
virsh start TestMachine
virsh reset TestMachine # forceful shutdown
virsh shutdown TestMachine # graceful shutdown
virsh destroy TestMachine # unplug power
virsh unddefine TestMachine
virsh undefine --remove-all-storage Testmachine

virsh define testmachine.xml
virsh sutostart TestMachine
virsh dominfo TestMachine
vrish setvcpus TestMachine 2 --config
virsh destroy TestMachine
virsh dominfo TestMachine
virsh setmaxmem TestMachine 2048 --config

## Create and Boot a Virtual Machine
download iso disk image # mimial cloud image
checksum:
sha256
sha256.gpg
`sha256sum -c SHA256SUMS 2>&1 | grep OK`
qemu-img info ubuntu-24.....img
qemu-img resize ubuntu-24............. .img 10G # expand the size of the virtual disk
## Storage pool
ls /var/lib/libvirt/
sudo cp ubuntu... img  /var/lib/libvirt/images/
virt-install # errors
virt-install --osinfo list
man virt-install
virt-install --help
virt-install --osinfo ubuntu24 --name ubuntu1 --memory 1024 --vcpus 1 --import --disk /var/lib/libverti/images/ubuntu24.... img --graphics none
ctrl + ] # close virtual machine

virsh list --all
virsh shutdown ubuntu1
virsh destroy ubuntu1
virsh undefine ubuntu1 --remove-all-storage
sudo cp ubuntu_img.img /var/lib/libvirt/images/

virt-install --osinfo ubuntu24 --name ubuntu1 --memory 1024 --vcpus 1 --import --disk /var/lib/libverti/images/ubuntu24.... img --graphics none --cloud-init root-password-generate=on 

copy root password from the output

alternate commands:
virt-install 
--osinfo detect=on # replace this command
--osinfo linux2022

# installing operating systems
virt-install --osinfo debian12 --name debian1 --memory 1024 --vcpus 1 --disk size=10 \
--location /var/lib/libvirt/boot/debian12-netinst.iso --graphics none --extra-args "console=ttyS0"

# we can download iso file direct from the internet, virt manager automatically manages this

Create, Delete, and Modify Local User Accounts
sudo adduser john # /home/john , /bin/bash
sudo passwd john
sudo deluser john
sudo deluser --remove-home john
sudo adduser --shell /bin/zsh --home /home/otherdirectory/ john
cat /etc/passwd # all stores in this directory
sudo adduser --uid 1100 smith
ls -l /home/
ls -ln /home/ # id
id
whoami

System account:
sudo adduser --system --no-create-home sysacc # indended for programs, daemon-uses this 
sudo deluser --remove-home john

sudo adduser john
sudo user-mod --home /home/ohter --move-home john # move home idr

sudo usermod -d /home/otherdir -m john # renamed
sudo usermod --login jane john = sudo ausermod -l jane john
sudo usermod --shell /bin/othershell jane
sudo usermod --lock jane # disable account, dont delte, login via ssh key only
sudo usermod --unlock jane
sudo usermod -e 2030-03-01 jane # expire user

password expiration fores user to change
sudo change --lastday 0 jane # let user change its password mandatory
sudo chage --lastday -1 jane
sudo chage --maxdays 30 jane
sudo chage --maxdays -1 jane # no expiry for password

Create, Delete, and Modify Local Groups and Group Memberships
sudo adduser john
sudo groupadd develpers
sudo gpasswd --add john develpers
sudo gpasswed --a john developers
groups john
sudo gpassword --delete john developers
sudo usermod -g developers john # primary
sudo usermod --gid developers john
groups john
gpasswd --help
sudo gorupmod --new-name programers dev
sudo grup -n prog dev
sudo groupdel programmers
sudo usermod --gid john john
sudo gourpdel programmers

Manage System-Wide Environment Profiles
printenv or env
HISTSIZE=222 # change size of histsize
history # shows commands in history
use .bashrc file for 
sudo vi /etc/environment
logout

sudo vi /etc/profile.d/lastlogin.sh # run command after login

Manage Template User Environment
sudo vi /etc/skel/README # custom file place under new users
```README
Please don't run CPU-intensive processes between 8AM and 10PM.
```
sudo adduser trinity
sudo ls -a /home/trinity

sudo vi /etc/skel/.bashrc # place .bashrc file under every newly user's home directory\

Configure User Resource Limits
sudo vi /etc/security/limits.conf
# <domain> <type> <item> <value>
trinity hard nproc 10
@developers soft nproc 10
* soft cpu 5 # every user but user trinity will overrite

trinity hard nproc 30
trinity hard nproc 20
trinity soft nproc 10

trinity - nproc 20 # hard limit fixed

item: nproc # max proc a user can open 
fsize: 1024
cpu: 1

man limits.conf

```bash
sudo vi /etc/security/limits.conf
triny - nproc 3
```

sudo -iu trinity
ps | less
 ls -a | grep bash | less
 process failed # more than 3 process

 logout

ulimit -a # see limit of a current session
ulimit -u 5000 # limit 

Manage User Privileges
groups
aaron family sudo # part of the group named sudo

add a user into a sudo group
sudo gpasswd -a trinity sudo # user group

sudo gpasswd -d trinity sudo # remove her from sudo 
who can use sudo:
sudo visudo # checks edits and helps us avoid mistakes
```bash
%sudo   ALL=(ALL:ALL) ALL
%group  host=(runas user field:run as group field) command list
user/group
host=(run_as_user:run_as_group) command_list

trinity ALL=(ALL) ALL # (ALL) for user,group both
%developers ALL=(ALL)

trinity ALL=(aaron,john) ALL
trinity ALL=ALL
trinity ALL=(ALL) /bin/ls, /bin/stat
trinity ALL= (ALL) NOPASSWD: ALL
```
sudo -u trinity ls /home/trinity


Manage Access to Root Account
sudo ls /root/
sudo --login or sudo -i # password for current user
logout
su - or su -l or su --login # password for root user only
when the root is locked, we can still use sudo --login but cannto use sudo -

if root does not have a passowrd, we can set the password for root
sudo passwd root
sudo passwd --unlock root or sudo passwd -u root, then run su - and type the root password for login

case 2:
sudo password --lock root or sudo passwd -l root # still be able to login via ssh


# Configure the System to Use LDAP User and Group Accounts
cat /etc/passwd
jereym:x:1000:1000:jeremy Morgan:/home/jeremy:/bin/bash

light weight directory access protocol (LDAP)
id john # no such user
id jane # no such user

now run LDAP server, setup client to use LDAP
lxd # docker for entire os
lxd init # at least 5GB
lxc import ldap-server.tar.xz

lxc list
lxc start ldap-server

install this package:
sudo apt update && sudo apt install libnss-ldapd # ends with d is extended version
dc=kodekloud,dc=com
/etc/nsswitch.conf # files system ldap (passwd: files systemd ldap)
sudo cat /etc/nslcd.conf

now system knows our additional accounts:
id john # exits now, group is ldapusers
id jane # exits now, group is ldapusers

users on ladap server
getent passwd # get all ldapp users and local users
getend passwd --service ldap
getent group --service ldap
ls /home # this location does not exist
we have to manually create home locations

every time a user login, this module would trigger
sudo pam-auth-update # create home dir on login
sudo login jane # now we have home directoyr
if we have 100 linux servers configured the same way, dealing with users and groups accounts will be easy, they will be available, one central location is used to deploy delte crud these users

# Configure IPv4 and IPv6 Networking and Hostname Resolution - Theory
ipv4 -> 8 bits -> 0 to 255 -> 11111111 = 255
192.168.1.101 -> 11000000.10101000.00000001.01100101
192.168.1.101/24. CIDR notation: classless inter-domain routing
first 24 bits of this address are the prefix of this network (192.168.1 is constant) 
255.255.255.     0 (represented by subnet)
{first 24 bits} {last 8 bits}
192.168.1 -> network prefix
.101      -> Device on the network
192.168.1.0 -> 192.168.1.255 is part of the same network
192.168.2.255 is part of the different network (does not have the same first 24 bits)

192.168.1.101/16 { 16 bits = network prefix }  { 16 bits = network }
255.255.0.0 (represented by subnet masking)
192.168.0.0 -> 192.168.255.255 is part of the same network

## ipv6 -> 128 bits
8 grops of numbers in hex format
0 - 9 - A=10,B,C,D,E and F=15
each number is separated by colon (:)
2001:0db8:0000:0000:0000:ff00:0042:8329 -> 2001:db8::ff00:42:8329
0000:0000:0000 -> ::
2001:0db8:0000:0000:0000:ff00:0042:8329/64 also supports CIDR notation
64 bits = 8 groups, there are total 16 groups i.e 128 bits
2001:db8::ff00:42:8329/24 (becomes)
CIDR calculator or subnet calculator

# Configure IPv4 and IPv6 Networking and Hostname Resolution - Demo
ip link # networking interfaces, loopback up: connect to itself (running on the same system)
enp03: real device
ip address
ip addr
ip a
ip -c address # colored
sudo ip link set dev enp0s8 up
sudo ip addr add 10.0.0.40/24 dev enp0s8 # assign ipv4 to newly interface
ip command is tempory, it resets after reboot
sudo ip link set dev enp0s8 down

# using netplan, permament settings
sudo netplan get # 
ls /etc/netplan
sudo cat /etc/netplan # same as netplan get
sudo vi /etc/netplan/99-mysettings.yaml
```yaml
network:
    ethernets:
        enp0s3:
            dhcp4: false
            dhcp6: false
            addresses:
                - 10.0.0.9/24
                - fe80::921b:eff:fe3d:abcd/64
    version: 2
```
sudo netplan try # changes wil revert in 108 seconds
sudo netplan try --timeout 30 # revert in 30 seconds
sudo chmod 00 /etc/netplan/99-mysettings.yaml
# settings will be re-applied automaticall after reboot
sudo netplan get
```yaml
network:
    version: 2
    ethernets:
        enp0s3:
            dhcp4: true
        enp0s8:
            addresses:
            - "10.0.0.9/24"
            - "fe80::921b:eff:fe3d:abcd/64"
            dhcp4: false
            dhcp6: false
```

sudo  vi /etc/netplan/99-mysettngs.yaml
```yaml
network:
    ethernets:
        enp0s3:
            dhcp4: false
            dhcp6: false
            addresses:
                - 10.0.0.9/24
                - fe80::921b:eff:fe3d:abcd/64
            nameservers:
                addresses:
                    - 8.8.4.4
                    - 8.8.8.8
            routes:
                - to: 192.168.0.0./24
                  via: 10.0.0.100 #  server acts as a middle man
                - to: default 
                  via: 10.0.0.1 #gateway, door to the external world
    version: 2
```
sudo netplan try
ip route # route is reapplied
resovectl status # check dns server here, only apply to one interfae

Global:
sudo vi /etc/systemd/resolved.conf # set dns server
sudo systemctl restart systemd-resolved.service
resovectl dns #show dns server globally

hostname:
sudo vi /etc/hosts # set hostname 127.0.123.123 dbserver
ping dbserver # auto translate to ip

ls /usr/share/doc/netplan/examples # docs about tools

# Start, Stop, and Check Status of Network Services
sshd, mariadbd, nginx
ss 
netstat
sudo ss -ltunp # l: listen, t: list tcp connections, u: udp connections, n: numeric values port number, p: processes
sudo ss -tunlp

local address:port  # 0.0.0.0:22 == [::]:22
Process: users: (("mariadbd)), sshd, sshd
systemctl status mriadb.service
systemctl status ssh.service # ssh on ubuntu, and sshd on redhat

sudo systemctl stop mariadb.service
sudo ss -ltunp
sudo systemctl disable mariadb.service # disable at auto start
sudo systemctl enable mariadb.service  # enable at auto start

sudo ss -ltunp # also shows pid of command
ps pid
sudo lsof -p pid # which file is opened by this command

sudo netstat -ltunp # uses same option as ss command
netstat might no available at all systems by default

# Configure Bridge and Bonding Devices - Theory
Bridge/Controlller
Bond: take two or more network devices and bond them
Benefits of Bonding:
if one network is down, other can still provide internet
high throughput, addition of networks
connections more reliable, increase stability
a program can use one or other but at a time once but with bonding, bonding can make all network as a single unity (logical combined) and if one network fails other provides stability and data transfer won't be interrupted

Bonding modes:
7 bonding modes, mode 0 to mode 6

Mode 0: "round-robin"      -> order, 1st, 2nd
Mode 1: "active-backup"    -> single interface
Mode 2: "XOR"              -> 
Mode 3: "broadcast"
Mode 4: "IEEE 802.3ad"
Mode 5: "adaptive transit load balancing"
Mode 6: "adabpitve load balancing"
