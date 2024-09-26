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



