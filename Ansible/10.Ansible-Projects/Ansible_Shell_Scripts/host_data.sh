# Set Ansible gathering to explicit to avoid automatic fact gathering
export ANSIBLE_GATHERING=explicit

# Run an ad-hoc Ansible command to check the uptime of all hosts in the inventory
ansible -a 'uptime' -i inventory all

# Create a playbook to check the Red Hat release version
echo '''
---
- hosts: all
  become: true
  tasks:
    - name: Check Red Hat release
      command: cat /etc/redhat-release
''' > playbook.yml

# Run playbook
ansible-playbook -i inventory -vv
