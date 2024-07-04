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
        dns_server:
            - server1.example.com
            - server2.example.com
            - server3.example.com
        dns_server:
            server1: "server1.example.com"
            server2: "server2.example.com"
            server3: "server3.example.com"
         
     tasks:
        - name: Add DNS server IP to resolv.conf (using variable dns_server_ip)
        - lineinfile:
            path: /etc/resolv.conf
            line: 'nameserver {{ dns_server }}' # {{ }} is a jinja2 templating
            line: nameserver {{ dns_server[0] }} # using list variable
            line: nameserver {{dns_server.server1}} # using dictionary variable

        - name: Add first DNS server from list to resolv.conf
        lineinfile:
            path: /etc/resolv.conf
            line: 'nameserver {{ dsn_server[0] }}'  # Accessing first item from list dsn_server

        - name: Add specific DNS server from dictionary to resolv.conf
        lineinfile:
            path: /etc/resolv.conf
            line: 'nameserver {{ dns_server_names.server1 }}'  # Accessing specific server from dictionary dns_server_names
```

### Variable Precedence

Variables in Ansible follow a specific precedence order, where higher levels take precedence over lower levels. Here's the precedence order from highest to lowest:

1. **--extra-vars**  
   Command-line extra variables (`-e` or `--extra-vars`) take the highest precedence. These variables are passed directly to the playbook command and override all other variable definitions.

2. **Play Vars**  
   Variables defined within a playbook (`vars` section at the play level) come next in precedence. They apply to all tasks within that specific play.

3. **Host Vars**  
   Variables defined for specific hosts in inventory files or directories (like `host_vars`) come next. These variables apply to tasks executed on those specific hosts.

4. **Group Vars**  
   Variables defined for host groups in inventory files or directories (like `group_vars`). These variables apply to all hosts within a specific group.

### Register output
```yaml
---
- name: Check /etc/hosts file
  hosts: all
  tasks:
  - shell: cat /etc/hosts
    register: result

- debug: 
  var: result.rc # rc means return code
```

### Variable Scope

## Interview Highlights
1. What is rc in register output?