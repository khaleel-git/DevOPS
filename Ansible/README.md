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
1. Host Scope
2. Play Score
3. Global Variables
#### Host Scope
Variables defined within a specific host context, such as `host_vars` or `group_vars` in inventory files or directories. These variables are accessible within tasks executed on those specific hosts or groups of hosts.
**Example (`host_vars/server1.yml`):**
```yaml
# File: host_vars/server1.yml
ansible_user: admin
ansible_ssh_pass: mypassword
```
#### Play Scope
Variables defined at the play level in an Ansible playbook (vars section within a play). These variables apply to all tasks within that play and are local to that play.
**Example:**
```yaml
---
- name: Example Playbook with Play Scope Variables
  hosts: all
  vars:
    play_var: "This variable is defined at the play level"

  tasks:
    - name: Task using play_var
      debug:
        msg: "{{ play_var }}"

```
#### Global Variables (--extra-vars)
Command-line extra variables (-e or --extra-vars) take the highest precedence. These variables are passed directly to the playbook command and override all other variable definitions.
**Example:**
`ansible-playbook example.yml -e "extra_var=value"`

### Magic Variables
1. hostvars
2. group_names
3. inventory_hostname
Ansible provides several built-in magic variables that allow you to access information about hosts, groups, and the execution environment dynamically.
#### 1. hostvars
The `hostvars` magic variable allows access to variables defined for other hosts in your inventory.
**Example Usage:**
```yaml
- name: Example Playbook using hostvars
  hosts: web1
  tasks:
    - debug:
        msg: "DNS Server of web2 is {{ hostvars['web2'].dns_server }}"
    - debug:
        msg: "Architecture of web2 is {{ hostvars['web2'].ansible_facts.architecture }}"
    - debug:
        msg: "Processor of web2 is {{ hostvars['web2']['ansible_facts']['processor'] }}"
```
#### 2. group_names
The group_names magic variable lists all groups to which the current host belongs.
*Example Usage:*
```yaml
- name: Example Playbook using group_names
  hosts: all
  tasks:
    - debug:
        msg: "Groups for current host: {{ group_names }}"
```
#### 3. inventory_hostname
The inventory_hostname magic variable provides the name of the current host as defined in the inventory.
*Example Usage:*
```yaml
- name: Example Playbook using inventory_hostname
  hosts: all
  tasks:
    - debug:
        msg: "Hostname of current host: {{ inventory_hostname }}"
```

## Ansible Facts
By default, Ansible gathers system facts from remote hosts using the `setup` module before executing tasks. This information is stored in variables and can be used in playbooks or templates. If you want to disable the automatic fact gathering and control when facts are collected, you can adjust the Ansible configuration file (`ansible.cfg`).
### Steps to Disable Automatic Fact Gathering
1. **Locate your `ansible.cfg` file:**
   - The `ansible.cfg` file can typically be found in `/etc/ansible/ansible.cfg` or in the current directory where you run Ansible (`./ansible.cfg`).

2. **Edit the `ansible.cfg` file:**
   - Add or modify the `gathering` setting under the `[defaults]` section to explicitly disable automatic fact gathering.

     ```ini
     [defaults]
     gathering = explicit
     ```

     Setting `gathering = explicit` means facts will not be gathered automatically. You will need to explicitly specify `gather_facts: yes` in your playbooks when you want to collect facts.

3. **Explicitly gather facts in playbooks:**
   - In your playbooks, where you need to gather facts, add `gather_facts: yes` at the play level.

     ```yaml
     ---
     - hosts: your_hosts
       gather_facts: yes
       tasks:
         - name: Your task here
           # Your tasks go here
     ```

## Ansible Playbooks
written in yaml format
single yaml file
a task is a single action to be performed
task:
1. execute a command
2. run a script
3. install a package
4. shutdown/restart
sample playbook, play1 and play2
properties: [name, hosts and tasks (lists)](dict)
hosts: set at play level, localhost, anyhost or group (first define in inventory file)
modules: difference action run by taks is called modules: command, script, yum, service

### verifying playbooks
un-noticed error (significant downtime), that's why we need verification (production env)
these issue lead to downtime, dataloss eg.
several moduels to verify playbook 
  1.check mode --check option[dont install but tell what it look like after install]
  2.Diff Mode: shows the diff b/w current state and new state, --check -diff (check and diff)
  3. Syntax Check: error-free, --syntax-check (check syntax) [ansible-playbook configure_ngnix.yml --syntax-check]

### Ansible-Lint
command-line tool which performs linting on asible playbooks, roles and collections
check code for errors, bugs, stylistic errors and suspicious constructs
use feedback to refine your playbooks
