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
