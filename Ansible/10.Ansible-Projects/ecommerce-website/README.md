# Deploying an E-Commerce App on a LAMP Stack with Ansible

Mediam Article: https://medium.com/@khaleel.org/deploying-an-ecommerce-app-on-lamp-stack-with-ansible-9d9cb956362e

Deploying a robust e-commerce application can be a complex and time-consuming task, especially when setting up the underlying infrastructure. Fortunately, Ansible provides a streamlined way to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack, making the process faster and more efficient. In this guide, I'll walk you through deploying an e-commerce application using Ansible on a CentOS server.

## Why Automate with Ansible?

Ansible simplifies server management and deployment by using YAML-based configuration files. Its automation capabilities help you quickly and consistently set up environments, allowing you to focus more on developing and scaling your e-commerce application rather than managing infrastructure.

## Prerequisites

Before diving into the deployment, ensure you have:

- **Ansible ansible [core 2.17.1]** installed on your local machine.
- **A CentOS-based VM or server** where the LAMP stack will be deployed.
- **SSH access** to the target server with appropriate privileges.
- **A Git repository** containing your e-commerce application code. For this guide, we use the kodekloud sample e-commerce app.

## Resources 

Ensure you have the following resources:

- db-load-script.sql
- index.php
- my.cnf
- deploy-lamp-stack.yml
- inventory

## Setting Up Your Inventory File

Define your target environment and variables in an inventory file. Create a file named `inventory.ini` with the following content:

```ini
[centos.vmware]
centos.vmware ansible_host=centos.vmware ansible_ssh_private_key_file=/home/khaleel/.ssh/root ansible_become_password=ah ansible_user=root

[all:vars]
httpd_port=80
repository=https://github.com/kodekloudhub/learning-app-ecommerce.git
mysqlservice=mysqld
mysql_port=3306
dbname=ecomdb
dbuser=ecomuser
dbpassword=ecompassword
```

This file specifies the target host and necessary variables used throughout the playbook.

Creating the Ansible Playbook
Here's a detailed breakdown of the playbook tasks to deploy the LAMP stack:

## 1. Installing Common Dependencies
Set up essential packages required for the deployment:
```
- name: Install common dependencies
  yum:
    name:
      - python3-libselinux
      - python3-libsemanage
      - firewalld
```
## 2. Setting Up the LAMP Stack
Install and configure MariaDB and Apache:
```
- name: Install LAMP stack components
  yum:
    name:
      - mariadb-server
      - python3-PyMySQL
    state: installed

- name: Deploy MySQL configuration
  copy:
    src: files/my.cnf
    dest: /etc/my.cnf

- name: Start and enable MariaDB
  service:
    name: mariadb
    enabled: yes
    state: started

- name: Start and enable firewalld
  service:
    name: firewalld
    state: started
    enabled: yes

- name: Configure firewall for MySQL
  firewalld:
    port: "{{ mysql_port }}/tcp"
    zone: public
    state: enabled
    immediate: yes
    permanent: yes
```
## The my.cnf file is:
```
[mysqld]
innodb-buffer-pool-size=5242880
# datadir=/var/lib/mysql
# socket=/var/lib/mysql/mysql.sock
#user=mysql
user=root
password=mysqlpasswd
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0
port=3306
```
## 3. Configuring the Database
Create the database and user, and load initial data:
```
- name: Create the database
  mysql_db:
    name: "{{ dbname }}"
    state: present
    login_user: root
    login_password: mysqlpasswd

- name: Create a new database user and grant permissions
  mysql_user:
    login_user: root
    login_password: mysqlpasswd
    name: "{{ dbuser }}"
    password: "{{ dbpassword }}"
    priv: "{{ dbname }}.*:ALL"
    state: present

- name: Load initial database data
  copy:
    src: files/db-load-script.sql
    dest: /tmp/db-load-script.sql

- name: Execute SQL script
  shell: mysql -f < /tmp/db-load-script.sql
```
The db-load-script.sql file is:

```
USE ecomdb;
CREATE TABLE products (
  id mediumint(8) unsigned NOT NULL auto_increment,
  Name varchar(255) default NULL,
  Price varchar(255) default NULL,
  ImageUrl varchar(255) default NULL,
  PRIMARY KEY (id)
) AUTO_INCREMENT=1;

INSERT INTO products (Name, Price, ImageUrl) VALUES 
  ("Laptop", "100", "c-1.png"),
  ("Drone", "200", "c-2.png"),
  ("VR", "300", "c-3.png"),
  ("Tablet", "50", "c-5.png"),
  ("Watch", "90", "c-6.png"),
  ("Phone Covers", "20", "c-7.png"),
  ("Phone", "80", "c-8.png"),
  ("Laptop", "150", "c-4.png");
```
## 4. Configuring the Web Server
Install Apache and PHP, and set up your web application:
```
- name: Install Apache and PHP
  yum:
    name:
      - httpd
      - php
      - php-mysqlnd
    state: present

- name: Install Git for application deployment
  yum:
    name: git
    state: installed

- name: Configure firewall for HTTP
  firewalld:
    port: "{{ httpd_port }}/tcp"
    zone: public
    immediate: yes
    permanent: yes
    state: enabled

- name: Update Apache to use index.php
  replace:
    path: /etc/httpd/conf/httpd.conf
    regexp: DirectoryIndex index.html
    replace: DirectoryIndex index.php

- name: Start and enable Apache
  service:
    name: httpd
    enabled: yes
    state: started

- name: Clone e-commerce repository and deploy application
  git:
    repo: "{{ repository }}"
    dest: /var/www/html/
    force: yes

- name: Copy index.php to web root
  copy:
    src: files/index.php
    dest: /var/www/html/index.php
```
## Deploying Your E-Commerce App
To deploy your e-commerce application, execute the playbook with the following command:
`ansible-playbook -i inventory.ini deploy_lamp_stack.yml`

Replace deploy_lamp_stack.yml with the actual name of your playbook if different.

## Troubleshooting Tips
Permission Denied Error (2002): Ensure MySQL is running and PHP is configured with the correct socket path. Review SELinux and firewall settings.
Service Failures: Verify that MariaDB and Apache services are correctly configured and have started. Check log files for error messages.
Connection Issues: Confirm that database credentials and hostnames in your inventory file are accurate.

## Conclusion
By leveraging Ansible, deploying a LAMP stack for your e-commerce application becomes a streamlined and efficient process. Automation reduces manual errors and speeds up deployment, allowing you to focus on growing your business. Customize the playbook as needed to fit your specific requirements and enjoy a smoother deployment experience.

Feel free to modify the playbook and inventory file according to your needs and share your feedback or improvements!