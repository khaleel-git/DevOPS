# Ansible Cheat Sheet

## Ansible Configuration Files
`/etc/ansible/ansible.cfg` #default config file 
### It has various sections
1. [defaults]
2. [inventory]
3. [previlege_escalation]
4. [paramiko_connection]
5. [ssh_connection]
6. [persistent_connection]
7. [colors]
### Overrite Ansible configs
`$ANSIBLE_CONFIG=/opt/ansible-web.cfg ansible-playbook playbook.yml`


## Ansible Configuration Variables
```bash
ANSIBLE_GATHERING=explicit ansible-playbook playbook.yml # only applicable to single playbook, to resolve this, we can export it to env variables
export ANSIBLE_GATHERING=explicit
ansible-playbook playbook.yml
```

## View Configuration
```bash
ansible-config list # Lists all configurations
ansible-config view # shows the current config file
ansible-config dump # Shows the current setting
```

## Default inventory file location and parameters:
```bash
Default_path: 
/etc/ansible/hosts

Parameters:
ansible_connection -ssh/winrm/localhost
ansible_port - 22/5986
ansible_user - root/user1/user2
ansible_ssh_pass - Password
```
### Example:
```
web ansible_host=server1.domain.com ansible_connection=ssh
