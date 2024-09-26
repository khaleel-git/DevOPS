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

