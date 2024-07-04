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
# Sample ini Inventory File

# Web Servers
web1 ansible_host=server1.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web2 ansible_host=server2.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web3 ansible_host=server3.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!

# Database Servers
db1 ansible_host=server4.company.com ansible_connection=winrm ansible_user=administrator ansible_password=Password123!


[web_servers]
web1 ansible_host=server1.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web2 ansible_host=server2.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!
web3 ansible_host=server3.company.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Password123!

[db_servers]
db1 ansible_host=server4.company.com ansible_connection=winrm ansible_user=administrator ansible_password=Password123!

[all_servers:children]
web_servers
db_servers
```

## Ansible Variables
```
ansible_connection
ansible_port
ansible_user
ansible_ssh_pass
```

### Using variables inside other variables:
```
-
    name: Add DNS server to resolv.conf
    hosts: localhost
     vars:
        dns_server: 10.1.250.10
     tasks:
        - lineinfile:
            path: /etc/resolv.conf
            line: 'nameserver {{ dns_server }}' # {{ }} is a jinja2 templating
            line: nameserver {{ dns_server[0] }} # call
```