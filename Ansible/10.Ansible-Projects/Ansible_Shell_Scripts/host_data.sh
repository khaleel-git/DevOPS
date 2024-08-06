export ANSIBLE_GATHERING=explicit
ansible -a 'uptime' -i inventory all
