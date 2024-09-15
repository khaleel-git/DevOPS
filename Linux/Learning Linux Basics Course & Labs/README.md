# Linux Basics Guide

## Package Management

Linux distributions use different package formats and managers to handle software installations and updates. Here’s a brief overview:

### Package Formats
- **RPM**: Used by Red Hat-based distributions like RHEL, CentOS, and Fedora.
- **DEB**: Used by Debian-based distributions like Ubuntu and Linux Mint.

### Red Hat vs CentOS
- **Red Hat**: Commercial distribution with paid support.
- **CentOS**: Community-driven and a free fork of Red Hat.

### Types of Package Managers
- **DPKG**: Low-level package manager for DEB packages.
- **APT**: High-level package manager that works with DPKG. (`apt-get` is its predecessor)
- **YUM**: High-level package manager for RPM packages. (`dnf` is its successor with more features)

### RPM Commands

- **Install a package**:
  ```bash
  rpm -ivh telnet.rpm  # i: install, v: verbose, h: hash marks
  ```

- **Uninstall a package**:
  ```bash
  rpm -e telnet.rpm
  ```

- **Upgrade a package**:
  ```bash
  rpm -Uvh telnet.rpm  # U: upgrade, v: verbose, h: hash marks
  ```

- **Query package**:
  ```bash
  rpm -q telnet.rpm
  ```

- **Verify package**:
  ```bash
  rpm -Vf telnet.rpm
  ```

### YUM
- **Configuration**:
  ```bash
  /etc/yum.repos.d/    # Repository configuration directory
  /etc/yum.repos.d/redhat.repo
  /etc/yum.repos.d/nginx.repo
  ```

- **Usage**:
  ```bash
  yum install telnet  # Install package
  yum remove telnet   # Remove package
  ```

### APT vs APT-GET
- **APT**: Provides a more user-friendly experience with progress bars and search capabilities.
  ```bash
  apt update
  apt install vim
  apt search package-name
  ```

- **APT-GET**: Older and does not have integrated search functionality.
  ```bash
  apt-get update
  apt-get install vim
  ```

## File Compression and Archival

### Common Commands

- **Check file size**:
  ```bash
  du -sk test.img  # Size in KB
  du -sh test.img  # Size in MB
  du -lh test.img  # Human-readable size
  ```

- **Archive files**:
  ```bash
  tar -cf test.tar file1 file2 file3  # Create tar archive
  tar -xf test.tar  # Extract tar archive
  tar -zcf test.tar.gz file1 file2  # Create gzip compressed tar archive
  ```

### Compression Utilities
- **bzip2**: Compress files with `.bz2` extension.
  ```bash
  bzip2 file.txt  # Compress
  bunzip2 file.txt.bz2  # Decompress
  ```

- **gzip**: Compress files with `.gz` extension.
  ```bash
  gzip file.txt  # Compress
  gunzip file.txt.gz  # Decompress
  ```

- **xz**: Compress files with `.xz` extension.
  ```bash
  xz file.txt  # Compress
  unxz file.txt.xz  # Decompress
  ```

- **View compressed file contents**:
  ```bash
  zcat file.txt.gz  # View gzip compressed file
  bzcat file.txt.bz2  # View bzip2 compressed file
  ```

## Searching for Files and Patterns

- **Locate files**:
  ```bash
  locate city.txt  # Quick search
  updatedb  # Update database for locate
  ```

- **Find files**:
  ```bash
  find /dir -name city.txt  # Search for a file by name
  ```

- **Search within files**:
  ```bash
  grep "search_term" file.txt  # Case-sensitive search
  grep -i "search_term" file.txt  # Case-insensitive search
  grep -r "search_term" /dir  # Recursive search
  grep -v "ignore_term" file.txt  # Exclude lines containing a term
  grep -w "word" file.txt  # Match whole word
  grep -A1 "pattern" file.txt  # Print matched line and one after
  grep -B1 "pattern" file.txt  # Print matched line and one before
  ```

## I/O Redirection

- **Standard Streams**:
  - **stdin**: Input
  - **stdout**: Output
  - **stderr**: Error output

- **Redirect output**:
  ```bash
  echo $SHELL > shell.txt  # Overwrite content
  echo $SHELL >> shell.txt  # Append to file
  ```

- **Redirect error messages**:
  ```bash
  cat missing_file 2> error.txt  # Redirect errors to file
  cat missing_file 2>> error.txt  # Append errors to file
  ```

- **Discard unwanted output**:
  ```bash
  cat missing_file 2> /dev/null  # Discard errors
  ```

## Command Line Pipes

- **Using pipes**:
  ```bash
  grep Hello sample.txt | less  # Pipe output to less
  ```

- **Tee command**:
```bash
  echo $SHELL | tee shell.txt  # Write to file and stdout
  echo $SHELL | tee -a shell.txt  # Append to file and stdout
```

## VIM Editor
- **Insert mode**:
  Press `i` to enter insert mode.

- **Save and exit**:
  Press `Esc`, then type `:wq` and press `Enter`.

- **Exit without saving**:
  Press `Esc`, then type `:q!` and press `Enter`.

- **Search within file**:
  Press `Esc`, then type `/search_term` and press `Enter`.

- **Replace text**:
  Press `Esc`, then type `:%s/old_text/new_text/g` and press `Enter`.

- **Navigate**:
  - `j`: Move down
  - `k`: Move up
  - `h`: Move left
  - `l`: Move right
  - `x`: Remove a character
  - `yy`: Copy a line
  - `p`: Paste a line
  - `dd`: Delete a line
  - `d3d`: Delete the first 3 lines
  - `u`: Undo
  - `Ctrl + r`: Redo

- **Insert mode shortcuts**:
  - `A`: Move to the end of the line and insert.
  - `I`: Move to the beginning of the line and insert.

### Checking Default Editors

```bash
update-alternatives --display editor
```

---

## Networking

### /etc/hosts

You can use the `/etc/hosts` file to add local DNS entries for quick name resolution.

```bash
192.168.0.1 db-server
192.168.0.2 web-server
192.168.0.3 nfs
```

### DNS Server Setup

You can configure DNS servers in the `/etc/resolv.conf` file:

```bash
nameserver 192.168.1.100
nameserver 8.8.8.8  # Google's public DNS
search mycompany.com prod.mycompany.com
```

For more information about DNS resolution, check `/etc/nsswitch.conf` and modify the order of DNS lookups:

```bash
hosts: files dns
```

### Record Types

- **A Record**: Maps domain to IPv4 address.
- **AAAA Record**: Maps domain to IPv6 address.
- **CNAME**: Maps a domain to another domain.

### Test DNS Resolution

- `nslookup`: Basic DNS query tool.
- `dig`: More detailed DNS query tool.

### Switching

Assign IP addresses to nodes within a network switch:

```bash
ip addr add 192.168.1.10/24 dev eth0  # Assign IP to node A
ip addr add 192.168.1.11/24 dev eth0  # Assign IP to node B
```

### Routing

Routers connect different networks, and you can view and modify routing tables with the following commands:

```bash
ip route                # View routing table
ip route add ip/24 via ip # Add routes to the table
```

Make an interface active:

```bash
sudo ip link set dev eth0 up
```

Set a default gateway:

```bash
sudo ip r add default via 172.16.238.1
```

### Troubleshooting Network Issues

- **Check interface status**:
  ```bash
  ip link
  ```

- **Check DNS resolution**:
  ```bash
  nslookup domain.com
  ```

- **Check network connectivity**:
  ```bash
  traceroute domain.com
  ```

- **Check open ports**:
  ```bash
  netstat -an | grep 80 | grep -i LISTEN
  ```

---

# Linux Accounts Management

In Linux, managing users, groups, and access control is a key part of system administration. This guide provides detailed instructions on managing Linux accounts, access control, and other related areas.

## Access Control

Linux provides various tools and mechanisms to manage user access and security:

- **PAM (Pluggable Authentication Modules)**: A flexible mechanism for authenticating users.
- **Network Security**: Tools like `iptables` and `firewalld` help in managing firewall rules.
- **SSH Hardening**: Restrict SSH access to authorized users only.
- **SELinux (Security-Enhanced Linux)**: Provides enhanced security policies to isolate applications running on the system.

---

## User and Group Information

### Files:
- **User data** is stored in `/etc/passwd`.
- **Group data** is stored in `/etc/group`.

Each user has:
- **UID**: User Identifier
- **GID**: Group Identifier
- **Home Directory**
- **Shell**: The command-line interface the user interacts with.

### Example of `/etc/passwd`:

```bash
bob:x:1001:1001::/home/bob:/bin/bash
```

In this example:
- `bob` is the username.
- `x` indicates that the password is stored in `/etc/shadow`.
- `1001` is both the UID and the GID.
- `/home/bob` is the user's home directory.
- `/bin/bash` is the default shell.

### Example of `/etc/group`:

```bash
developer:x:1001:bob
```
This indicates that the `developer` group (GID 1001) has `bob` as a member.

### Useful Commands:

- **View user information**:
  ```bash
  id bob  # Shows UID, GID, and group memberships
  ```

- **Check user details in /etc/passwd**:
  ```bash
  grep -i bob /etc/passwd
  ```

---

## System Accounts

- **Admin/Superuser (Root)**: Root user has UID 0 and full access to the system.
- **System Accounts**: Accounts like `ssh`, `mail` typically have UID between 100-500 or 500-1000.
- **Service Accounts**: For example, `nginx` often runs under its own service account.

### View Account Details:

- **Current User**:
  ```bash
  who
  ```

- **Last Login Information**:
  ```bash
  last
  ```

- **Switch to another user**:
  ```bash
  su -  # Switch to root
  su -c "whoami"  # Execute a command as another user
  ```

---

## Sudo Privileges

Sudo allows non-root users to execute commands as root.

- **Manage sudo permissions**:
  Sudo access is controlled via the `/etc/sudoers` file.

  Use the following command to safely edit the sudoers file:
  ```bash
  visudo
  ```

### Example Sudoers Entry:
```bash
ALL=(ALL) ALL
```
This entry means that the user can execute any command as any user or group.

---

## Shell Access

- **Nologin Shell**: Users with `/usr/sbin/nologin` as their shell cannot log in interactively.

  Check if a user has `nologin` access:
  ```bash
  grep -i ^root /etc/passwd
  ```

---

## Access Control Files

### `/etc/shadow` File:
The `/etc/shadow` file stores encrypted user passwords and account aging information.

#### Example:
```bash
bob:$6$hashedpassword:18188:0:99999:7:::
```
- `$6$`: Hashing algorithm (SHA-512).
- `18188`: Last password change (days since epoch).
- `0`: Minimum number of days between password changes.
- `99999`: Maximum number of days before the password must be changed.

### View User Information in `/etc/shadow`:
```bash
grep -i bob /etc/shadow
```

### `/etc/group` File:
Stores group information:
```bash
developer:x:1001:bob
```

---

## User Management

### Adding a User:

- **Add a new user**:
  ```bash
  useradd bob
  passwd bob  # Set password
  ```

  Check user details:
  ```bash
  grep -i bob /etc/passwd
  grep -i bob /etc/shadow
  ```

- **Add a user with custom UID, GID, home directory, and shell**:
  ```bash
  useradd -u 1009 -g 1009 -d /home/robert -s /bin/bash -c "comment" robert
  ```

### Deleting a User:

- **Remove a user**:
  ```bash
  userdel bob
  ```

  Optionally, remove the user's home directory:
  ```bash
  userdel -r bob
  ```

---

## Group Management

- **Add a new group**:
  ```bash
  groupadd -g 1011 developer
  ```

- **Delete a group**:
  ```bash
  groupdel developer
  ```

---

## Password Management

Users can change their password using the `passwd` command:

- **Set a password for a user**:
  ```bash
  passwd bob
  ```

- **Change your own password**:
  Simply run:
  ```bash
  passwd
  ```

### User Account Aging:
The `/etc/shadow` file includes fields for password aging:
- **minage**: Minimum number of days between password changes.
- **maxage**: Maximum number of days the password is valid.
- **warn**: Number of days before the password expires, the user will be warned.

---

# Linux File Permissions and Ownership

Each file and directory in Linux has permissions assigned to three categories of users:

- **Owner (u)**: The user who owns the file.
- **Group (g)**: A group of users assigned to the file.
- **Other (o)**: Any other user who has access to the file.

The permissions define what each category can do with the file:

- **r** (read): View the file's contents.
- **w** (write): Modify or delete the file.
- **x** (execute): Run the file as a program (if it's a script or executable).

---

### Example: Listing File Permissions

```bash
ls -l bash-script.sh
```
Output:
```
-rwxrwxr-x 1 bob bob 89 Mar 17 01:35 bash-script.sh
```

Breaking this down:

- `-rwxrwxr-x` — File permissions (owner, group, other).
- `bob` — The owner of the file.
- `bob` — The group that owns the file.
- `89` — The file size (in bytes).
- `Mar 17 01:35` — Last modified date and time.
- `bash-script.sh` — The file name.

### Permission Breakdown:
```
-rwxrwxr-x
|  |  |  |    
|  |  |  └─  Other: r-x (Read, no Write, Execute)
|  |  └───── Group: rwx (Read, Write, Execute)
|  └──────── Owner: rwx (Read, Write, Execute)
└─────────── File type: - (regular file)
```

---

### Numeric Representation of Permissions

Each permission (read, write, execute) has a corresponding numeric value:
- **Read (r)**: 4
- **Write (w)**: 2
- **Execute (x)**: 1
- **No permission (-)**: 0

Permissions for the owner, group, and others are expressed as a three-digit number. Each digit is the sum of the values for read, write, and execute.

Example:
- **rwx** = 4 + 2 + 1 = **7**
- **rw-** = 4 + 2 + 0 = **6**
- **r-x** = 4 + 0 + 1 = **5**

So, `rwxrwxr-x` can be represented as **775**.

---

### Special Permission Scenarios

If the owner does not have execute (`x`) permissions but the group does, Linux will still apply the owner's permissions, effectively overriding the group permissions.

### Common Permission Values:
- **7** — Read, write, execute
- **6** — Read, write
- **5** — Read, execute
- **3** — Write, execute
- **0** — No permission

```
# simple representation
Read,Write,Execute: 7
Read,Write,-      : 6
Read,-,Execute    : 5
-,Write,Execute   : 3
chmod u+rwx,g+r-x,o-rwx         # combined
```
---

## Changing Permissions

Use the `chmod` command to modify file permissions.

### Basic Syntax:
```bash
chmod [who]=[permissions] filename
```
Where `who` can be:
- **u**: Owner (user)
- **g**: Group
- **o**: Others
- **a**: All (Owner, Group, and Others)

### Examples:

- **Grant full access to the owner**:
  ```bash
  chmod u+rwx file.txt
  ```
  Resulting permissions: `rwx------`

- **Grant read-only access to everyone**:
  ```bash
  chmod a+r file.txt
  ```
  Resulting permissions: `r--r--r--`

- **Remove all permissions from others**:
  ```bash
  chmod o-rwx file.txt
  ```
  Resulting permissions: `rwxrwx---`

### Numeric Mode:
You can also use numeric values to set permissions more quickly.

- **Grant full access to owner, group, and others**:
  ```bash
  chmod 777 file.txt
  ```
  Resulting permissions: `rwxrwxrwx`

- **Grant read and execute access to owner, group, and others**:
  ```bash
  chmod 555 file.txt
  ```
  Resulting permissions: `r-xr-xr-x`

- **Grant read/write access to owner and group, no access for others**:
  ```bash
  chmod 660 file.txt
  ```
  Resulting permissions: `rw-rw----`

- **Grant full access to owner, read/execute to group, no access to others**:
  ```bash
  chmod 750 file.txt
  ```
  Resulting permissions: `rwxr-x---`

---

## Changing File Ownership

The **owner** and **group** can be changed using the `chown` command.

### Basic Syntax:
```bash
chown [owner]:[group] filename
```

### Examples:

- **Change the owner of a file**:
  ```bash
  chown bob bash-script.sh
  ```
  This command changes the owner of `bash-script.sh` to `bob`.

- **Change the owner and group of a file**:
  ```bash
  chown bob:developer file.txt
  ```
  This changes the owner to `bob` and the group to `developer`.

- **Change the group of a file**:
  ```bash
  chgrp android file.txt
  ```
  This changes the group of `file.txt` to `android`.

---

## Practical Tips

- Always be cautious when setting file permissions—giving write access to others can pose a security risk.
- Use `chmod` carefully on sensitive files (like scripts and config files).
- Use numeric permissions for quicker commands, but symbolic mode (`u`, `g`, `o`) for more clarity.
- For collaborative environments, set group permissions properly to control access.

---

# SSH and SCP 
---

## SSH (Secure Shell)

- **Connect to a remote server via hostname or IP:**
  ```bash
  ssh hostname
  ssh user@hostname
  ssh user@ip_address
  ```
  
- **Specify a different user for the connection:**
  ```bash
  ssh -l user hostname  # Alternative to user@hostname
  ssh -l user ip_address
  ```

Once you're connected, you can execute commands on the remote machine as though you're logged in locally.

### SSH Key-Based Authentication

SSH keys provide a secure and convenient way to log into servers without needing to type a password. It’s based on **key pairs** (a private key for the user and a public key for the server).

#### Generate an SSH Key Pair

To generate your SSH keys (a public and private key pair), run:
```bash
ssh-keygen -t rsa
```

You'll now have two files:
- **Private Key** (kept secret, used to authenticate): `~/.ssh/id_rsa`
- **Public Key** (shared with the server): `~/.ssh/id_rsa.pub`

#### Copying Your Public Key to the Server

To enable passwordless login, copy your public key to the remote server:
```bash
ssh-copy-id user@hostname
```

This places your public key into the server’s `~/.ssh/authorized_keys` file, allowing you to log in without needing a password.

### SSH Config for Convenience

Tired of typing out full command options every time? You can simplify your SSH connections with an SSH configuration file:

Edit (or create) `~/.ssh/config`:
```bash
Host myserver
  HostName example.com
  User bob
  Port 2222
  IdentityFile ~/.ssh/id_rsa
```

Now you can just type:
```bash
ssh myserver
```

### SSH Tunneling (Port Forwarding)

SSH also allows port forwarding, which lets you access remote services securely. For example, if you want to access a remote web server running on port 8080:

```bash
ssh -L 8080:localhost:8080 user@hostname
```

This will map the remote port 8080 to your local port 8080, letting you access the service locally via `http://localhost:8080`.

---

## SCP (Secure Copy Protocol)

SCP is used for copying files securely between hosts using SSH. With SCP, data is encrypted, keeping your files safe from prying eyes during transfer.

### Basic SCP Commands

- **Copy a file from your local machine to a remote server:**
  ```bash
  scp /path/to/local/file.txt user@hostname:/path/to/remote/directory
  ```

- **Copy a file from the remote server to your local machine:**
  ```bash
  scp user@hostname:/path/to/remote/file.txt /path/to/local/directory
  ```

### Recursive Copy

Need to copy a whole directory? You can do that with the `-r` (recursive) option:

```bash
scp -r /path/to/local/folder user@hostname:/path/to/remote/folder
```

### Preserving Ownership and Permissions

To preserve file ownership and permissions during transfer, use the `-p` flag:
```bash
scp -pr /path/to/local/folder user@hostname:/path/to/remote/folder
```

### Transfer Between Two Remote Hosts

You can even use SCP to transfer files between two remote servers (without needing to copy them locally first):
```bash
scp user1@host1:/path/to/file user2@host2:/path/to/destination
```

---

## Enhancing SSH Security

Here are a few ways to make your SSH usage more secure:

### Change the Default SSH Port
The default SSH port (22) is a common target for attackers. Changing it can reduce your exposure to brute force attacks:
```bash
# Edit the SSH configuration file:
sudo nano /etc/ssh/sshd_config

# Change the port:
Port 2222
```

### Disable Root Login

Disabling SSH access for the root user enhances security by forcing users to log in as a non-root user and use `sudo` for elevated privileges.

```bash
# In /etc/ssh/sshd_config:
PermitRootLogin no
```
---
# Network Security with IPTables and Firewalld

This guide covers the essentials of network security using **IPTables** and **Firewalld** on Linux. These tools allow you to define rules to control incoming and outgoing traffic, helping secure your system against unauthorized access and attacks.

---

## Introduction to IPTables

**IPTables** is a command-line firewall utility that uses policy chains to control the incoming and outgoing packets. Each packet that traverses the system is checked against a chain of rules to determine whether it should be allowed or denied.

- **Chain of Rules**: The firewall processes rules from top to bottom. As soon as a rule matches the packet, the action specified in the rule is executed, and the packet stops moving through the chain.
- **Common Chains**: 
  - `INPUT`: Controls incoming packets.
  - `OUTPUT`: Controls outgoing packets.
  - `FORWARD`: Controls packets being routed through your system.

---

## Basic IPTables Syntax

Each rule follows a similar pattern:
```bash
iptables [CHAIN] [OPTIONS] -p [PROTOCOL] -s [SOURCE_IP] -d [DEST_IP] --dport [PORT] -j [ACTION]
```
- `-A`: Adds a rule to the chain.
- `-p`: Protocol (e.g., TCP, UDP, ICMP).
- `-s`: Source IP address.
- `-d`: Destination IP address.
- `--dport`: Destination port.
- `-j`: Action to take (e.g., ACCEPT, DROP, REJECT).

### Example: Allowing SSH Traffic

```bash
iptables -A INPUT -p tcp -s 192.168.1.100 --dport 22 -j ACCEPT
```
- This rule allows incoming **SSH** connections from the IP `192.168.1.100` to port `22` on the local machine.

### Example: Dropping SSH Traffic from All Other IPs

```bash
iptables -A INPUT -p tcp --dport 22 -j DROP
```
- After allowing specific IPs for SSH, this rule will drop any other connection attempts to port 22.

### Processing Order: Top to Bottom

IPTables evaluates rules from top to bottom. The first matching rule determines the action taken on the packet. Be mindful of rule order to avoid unexpected behavior.

---

## Outgoing Traffic Control

You can also control **outgoing** traffic with the `OUTPUT` chain.

### Example: Allowing Specific Outbound Connections

```bash
iptables -A OUTPUT -p tcp -d 203.0.113.1 --dport 5432 -j ACCEPT  # Allow PostgreSQL to a specific IP
iptables -A OUTPUT -p tcp -d 203.0.113.2 --dport 80 -j ACCEPT    # Allow HTTP to a specific IP
```

### Example: Blocking All Other Outbound HTTP and HTTPS

```bash
iptables -A OUTPUT -p tcp --dport 80 -j DROP   # Block all HTTP traffic
iptables -A OUTPUT -p tcp --dport 443 -j DROP  # Block all HTTPS traffic
```

### Inserting Rules with `-I`

Use the `-I` option to insert a rule at a specific position within the chain, rather than appending it to the end.

```bash
iptables -I OUTPUT 1 -p tcp -d 203.0.113.3 --dport 443 -j ACCEPT  # Insert a rule at position 1
```

### Deleting a Rule

If you need to delete a rule, you can do so by specifying its position in the chain.

```bash
iptables -D OUTPUT 5  # Delete the 5th rule in the OUTPUT chain
```

---

## Example: Database Access Control

Here’s how you can secure your database by only allowing access from specific IP addresses and blocking all other traffic:

```bash
iptables -A INPUT -p tcp -s 203.0.113.4 --dport 5432 -j ACCEPT  # Allow PostgreSQL from a specific IP
iptables -A INPUT -p tcp --dport 5432 -j DROP                   # Block all other PostgreSQL traffic
```

### Verifying Rules

To check the status of your rules, you can use:

```bash
iptables -L
```

To inspect the listening ports and connections:

```bash
netstat -an | grep 5432  # Check PostgreSQL port status
```

---

## Ephemeral Port Range

The Linux kernel uses ephemeral ports (dynamic ports) for client-side connections. By default, the range is between **32768 and 60999**. These ports are temporarily assigned for short-lived connections.

```bash
cat /proc/sys/net/ipv4/ip_local_port_range
```

---

## Firewalld

**Firewalld** is a more modern and user-friendly alternative to IPTables. It supports dynamic rules, which means you don’t need to reload the entire rule set when making changes.

### Basic Firewalld Commands

To start or stop `firewalld`:
```bash
sudo systemctl start firewalld
sudo systemctl stop firewalld
```

### Open a Port in Firewalld

```bash
sudo firewall-cmd --permanent --add-port=5432/tcp  # Open PostgreSQL port
sudo firewall-cmd --reload                         # Reload the firewall
```

### Blocking a Port

```bash
sudo firewall-cmd --permanent --remove-port=5432/tcp  # Block PostgreSQL port
sudo firewall-cmd --reload                            # Reload the firewall
```

### Listing Active Rules

```bash
sudo firewall-cmd --list-all
```

---

# Cronjobs

Cronjobs allow for the scheduling of tasks to run at specific times or intervals. The syntax consists of five fields followed by the command to be executed:

```
m h dom mon dow command
```

- **m**: Minute (0 - 59)
- **h**: Hour (0 - 23)
- **dom**: Day of the month (1 - 31)
- **mon**: Month (1 - 12)
- **dow**: Day of the week (0 - 7) (Sunday = 0 or 7)

## Examples:

### 08:10 AM on 19th February, Monday
```bash
minutes     hour    day     month   weekday
10          8       19      2       1
```

### 08:10 AM on 19th February, Any Weekday
```bash
minutes     hour    day     month   weekday
10          8       19      2       *
```

### 08:10 AM on 19th of Every Month, Any Weekday
```bash
minutes     hour    day     month   weekday
10          8       19      *       *
```

### 08:10 AM Every Day of Every Month, Any Weekday
```bash
minutes     hour    day     month   weekday
10          8       *       *       *
```

### 10th Minute of Every Hour, Every Day, Every Month, Any Weekday
```bash
minutes     hour    day     month   weekday
10          *       *       *       *
```

### Every Minute of Every Hour, Every Day, Every Month, Any Weekday
```bash
minutes     hour    day     month   weekday
*           *       *       *       *
```

### Every 2 Minutes of Every Hour, Every Day, Every Month, Any Weekday
```bash
minutes     hour    day     month   weekday
*/2         *       *       *       *
```

### Every Day at 9 PM
```bash
minutes     hour    day     month   weekday
0           21      *       *       *
```

---

## Managing Cronjobs

### List All Cronjobs
To list the cronjobs for the current user:
```bash
crontab -l
```

### Edit Cronjobs
To edit the cronjob file:
```bash
crontab -e
```

### View Cronjob Logs
Check cronjob logs:
```bash
tail /var/log/syslog
```
--- 

# Service Management

Service management in Linux, particularly with **systemd**, allows for the control and monitoring of system services. The main tools used are `systemctl` for managing services and `journalctl` for viewing logs. This guide explains how to manage, create, and troubleshoot services.

---

## Systemd & Systemctl

`systemd` is a system and service manager for Linux, responsible for starting services during boot, stopping them during shutdown, and much more. The main interface to interact with `systemd` is `systemctl`.

### Create a Service

To create a service, define a service unit file in `/etc/systemd/system/`:
```bash
# /etc/systemd/system/project.service
[Service]
ExecStart= /bin/bash /usr/bin/project.sh
```

### Manage the Service:
```bash
systemctl start project.service   # Start the service
systemctl status project.service  # Check the status of the service
systemctl stop project.service    # Stop the service
```

### Updating the Service

You can update the service with more detailed configurations like dependencies, restart policies, etc.:

```bash
# /etc/systemd/system/project.service
[Unit]
Description=Python Django for my project
After=postgresql.service

[Service]
ExecStart=/bin/bash /usr/bin/project.sh
User=my_user
Restart=on-failure
RestartSec=10

[Install]
WantedBy=graphical.target
```

After updating a service unit file, reload the systemd manager configuration:
```bash
systemctl daemon-reload   # Reloads systemd configurations
systemctl start project.service
```

### Common Systemctl Commands

- **Start/Stop/Restart Services**:
    ```bash
    systemctl start docker       # Start a service
    systemctl stop docker        # Stop a service
    systemctl restart docker     # Restart a service
    systemctl reload docker      # Reload service configuration without restarting
    ```

- **Enable/Disable Services** (for autostart on boot):
    ```bash
    systemctl enable docker      # Enable a service
    systemctl disable docker     # Disable a service
    ```

- **Check Service Status**:
    ```bash
    systemctl status docker      # Check the status of a service
    ```

- **Reload systemd after making changes**:
    ```bash
    systemctl daemon-reload      # Reload the systemd manager configuration
    ```

- **Edit Service Unit Files**:
    ```bash
    systemctl edit project.service --full   # Edit service configuration file
    ```

- **Manage Targets** (set the system run-level equivalent):
    ```bash
    systemctl get-default                # Get current target (runlevel)
    systemctl set-default multi-user.target   # Set default target to multi-user mode
    ```

- **List All Units**:
    ```bash
    systemctl list-units --all    # List all available systemd units (services)
    ```

---

## Journalctl

`journalctl` is a tool for querying and viewing logs collected by `systemd`. It's particularly useful for troubleshooting services managed by systemd.

### Common Journalctl Commands

- **View all logs**:
    ```bash
    journalctl   # View all log entries
    ```

- **View logs for the current boot**:
    ```bash
    journalctl -b
    ```

- **View logs for a specific service**:
    ```bash
    journalctl -u docker.service   # View logs for the docker service
    ```

- **View logs for a specific time**:
    ```bash
    journalctl --since "2023-09-01 10:00:00"  # View logs since a specific date and time
    journalctl --until "2023-09-01 12:00:00"  # View logs up until a specific date and time
    ```
---

Storage in Linux:
df -h  # overall
du -lh # check space for a file

Disk Partitions:
linux filesystem, partions, nfs, external storage devices (DAS/NAS/SAN), logical volume manage (LVM)

Block devices:
ssd, hdd, found under dev, because data is written in blocks/chunks
lsblk
ls -l /dev/ | grep "^b"
sda1, sda2, sda3

each block device has major and minor number

1 ram, 3 hard disk or cd rom, 6 parralel printers, 8 scsi disk, fix naming conventions which starts with sd

fdisk:
sudo fdisk -l /dev/sda
can create partitions
gpt disk label

partition types: 
1. primay (max 4) MBR: master boot record, max size: 2TB
2.extended partition (can't be used by its own, must used with other partitoin)
3.logical partition (created withing extended partition)

GPT: GUid partition table
unlimited no of partitions per disk, limited by os
always the best choice


sdb:
gdisk /dev/sdb # create parition, imporved version of fdisk
lsblk /dev/vdc
# create a new gpt partion of 500MB
```
bob@caleston-lp10:~$ sudo gdisk /dev/vdb
GPT fdisk (gdisk) version 1.0.3

Partition table scan:
  MBR: not present
  BSD: not present
  APM: not present
  GPT: not present

Creating new GPT entries.

Command (? for help): n
Partition number (1-128, default 1): 
First sector (34-2097118, default = 2048) or {+-}size{KMGTP}: 
Last sector (2048-2097118, default = 2097118) or {+-}size{KMGTP}: +500M
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8300
Changed type of partition to 'Linux filesystem'

Command (? for help): w

Final checks complete. About to write GPT data. THIS WILL OVERWRITE EXISTING
PARTITIONS!!

Do you want to proceed? (Y/N): y
OK; writing new GUID partition table (GPT) to /dev/vdb.
The operation has completed successfully.
bob@caleston-lp10:~$ 
```

file System in Linux
when you create a parition it, does not writeable able, before using the partition we need to create a filesystem
EXT2 & EXT3, 2TB file size and 4TB volume size.
in ext2 if systme powers fail, it can take some time to boot back in
in ext3 it does not have drawback, qucker boot in terms of failure
ext4, 6TB filezide, 1EXabyte , 