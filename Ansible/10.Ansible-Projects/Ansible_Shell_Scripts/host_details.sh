ANSIBLE_HOST_KEY_CHECKING=False ansible -a 'hostname' -i inventory all
ansible -m copy -a 'src=/etc/resolv.conf dest=/tmp/resolv.conf' -i inventory node00
