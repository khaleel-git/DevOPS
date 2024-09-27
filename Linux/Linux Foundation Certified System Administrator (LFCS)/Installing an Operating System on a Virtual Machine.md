virt-install --osinfo debian12 --name debian1 --memory 1024 --vcpus 1 --disk size=10 \
--location /var/lib/libvirt/boot/debian12-netinst.iso --graphics none --extra-args "console=ttyS0"

# we can download iso file direct from the internet, virt manager automatically manages this