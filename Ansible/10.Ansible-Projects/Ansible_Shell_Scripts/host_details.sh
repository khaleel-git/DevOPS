ANSIBLE_HOST_KEY_CHECKING=False ansible -a 'cat /etc/hosts' -i inventory all
ansible -m copy -a 'src=/etc/resolv.conf dest=/tmp/resolv.conf' -i inventory node00
