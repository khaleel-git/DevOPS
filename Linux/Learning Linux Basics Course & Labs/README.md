# Linux Basics Guide
Linux core concepts
Linux kernal
Linux Boot Sequence
System targets (runlevels)

linux kernal -> memory, cpu, devices and applications/process [communication]
memory management, process management, device drivers, system calls and security, monolithic, modular
kernal version: `uname`
```
uname -r
4.15.0-72-generic
4: kernal version
15: major version
0: minor version
72: patch level
generic: distro specific info


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

  sudo tar -C /opt/ -xvf caleston-code.tar.gz # unarchive
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
  sudo netstat -natulp | grep postgres | grep LISTEN
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

Create a new service called mercury.service with the following requirements.

Service name: - mercury.service, WorkingDirectory: - /opt/caleston-code/mercuryProject/, Command to run: /usr/bin/python3 manage.py runserver 0.0.0.0:8000.

Restart on failure and enable for multi-user.target.

Run as user mercury.

Set description: Project Mercury Web Application.

Create the unit file under /etc/systemd/system. Once done, enable and start the mercury.service.
```bash
[Unit]
Description=Python Django for my project

[Service]ExecStart=/usr/bin/python3 manage.py runserver 0.0.0.0:8000   
Restart=on-failure
WorkingDirectory=/opt/caleston-code/mercuryProject/
user=mercury
Description="Project Mercury Web Application"

[Install]
WantedBy=multi-user.target
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
# Storage in Linux

## Disk Usage

### Check Overall Disk Usage
```bash
df -h   # Shows disk space usage in human-readable format
```

### Check Space Used by a Specific File or Directory
```bash
du -lh  # Shows space used by files or directories in human-readable format
```

---

## Disk Partitions

Linux manages storage through disk partitions. Partitions can be part of internal drives, external storage devices (DAS, NAS, SAN), or managed using Logical Volume Management (LVM).

### Types of Storage Devices:
- **Block Devices**: SSD, HDD, etc. Found under `/dev/` since data is written in blocks.
- **Common Tools**:
  - `lsblk`: Lists information about all block devices.
  - `ls -l /dev/ | grep "^b"`: Lists block devices.
  - `sda1`, `sda2`, `sda3`: Example of block devices (SSD/HDD partitions).

### Block Device Naming:
Each block device has a major and minor number. Here are some common naming conventions:
- `1`: RAM devices
- `3`: Hard disks or CD-ROMs
- `6`: Parallel printers
- `8`: SCSI disks

---

## Working with Fdisk

`fdisk` is a utility to view and manage disk partitions on MBR and GPT-based disks.

### View Disk Partitions:
```bash
sudo fdisk -l /dev/sda
```

### Partition Types:
- **Primary Partition** (MBR): Up to 4 partitions, max size 2TB.
- **Extended Partition**: Cannot be used on its own, used to contain logical partitions.
- **Logical Partition**: Created within an extended partition.

### GPT (GUID Partition Table):
- Supports a larger number of partitions (limited by OS).
- Ideal for disks larger than 2TB.
- Preferred for modern systems.

---

## Creating Partitions with Gdisk

`gdisk` is a modern alternative to `fdisk` for managing GPT partitions.

### Create a New GPT Partition of 500MB:
```bash
sudo gdisk /dev/vdb

GPT fdisk (gdisk) version 1.0.3

Command (? for help): n
Partition number (1-128, default 1):
First sector (34-2097118, default = 2048) or {+-}size{KMGTP}:
Last sector (2048-2097118, default = 2097118) or {+-}size{KMGTP}: +500M
Current type is 'Linux filesystem'
Hex code or GUID (L to show codes, Enter = 8300): 8300

Command (? for help): w
Do you want to proceed? (Y/N): y
```

The above commands will create a new GPT partition of 500MB on `/dev/vdb`.

---

## Filesystems in Linux

When a partition is created, it is not yet usable. To make it functional, a **filesystem** must be created on the partition.

### Common Filesystems:
- **EXT2 & EXT3**: Support 2TB file size and 4TB volume size. EXT3 improves on EXT2 by offering faster boot times after power failures.
- **EXT4**: Supports 16TB file size and 1EB volume size. Can be mounted as EXT2 or EXT3.

### Creating and Mounting EXT4 Filesystem:

1. **Create Filesystem**:
    ```bash
    mkfs.ext4 /dev/sdb1
    ```

2. **Create Mount Point**:
    ```bash
    mkdir /mnt/ext4
    ```

3. **Mount the Partition**:
    ```bash
    mount /dev/sdb1 /mnt/ext4
    ```

4. **Verify Mounting**:
    ```bash
    df -hP | grep /dev/sdb1
    ```

### Persisting Mounts with fstab

To ensure the partition is mounted automatically on boot, add it to the `/etc/fstab` file:

```bash
vi /etc/fstab

# Example fstab entry
/dev/sdb1   /mnt/ext4   ext4   defaults   0   0
```
Explanation:
- `/dev/sdb1`: The block device.
- `/mnt/ext4`: The mount point.
- `ext4`: Filesystem type.
- `defaults`: Mount options (`rw`, `relatime`, etc.).
- `0 0`: Disable backups and filesystem checks.

### Check filesystem of a disk
```bash
bob@caleston-lp10:~$ sudo blkid /dev/vdc
[sudo] password for bob: 
/dev/vdc: UUID="a98c1340-b8d6-4305-a6e4-a39786374e3c" TYPE="ext2"
```
---

# Linux Storage Management: DAS, NAS, and SAN with NFS & LVM

In enterprise environments, efficient storage management is critical for high performance and scalability. This guide covers three primary storage architectures—**Direct Attached Storage (DAS)**, **Network Attached Storage (NAS)**, and **Storage Area Network (SAN)**—along with a comparison of **NFS** and **SAN**. Finally, we'll walk through setting up **LVM** (Logical Volume Manager) to manage storage dynamically in Linux.

---

## 1. Storage Types Overview

### Direct Attached Storage (DAS)

- **DAS** refers to external storage devices like **HDD** or **SSD** connected directly to a server.
- **Advantages**: High-speed access, simplicity, and no network overhead.
- **Limitations**: Limited scalability as it serves only the local server, making it suitable for small-scale setups.

**Example:**
You plug in an SSD directly to your Linux server via SATA or USB, and it's recognized under `/dev/sdb`. You format and mount it locally.

```bash
# Check if the device is connected
lsblk

# Create a filesystem
sudo mkfs.ext4 /dev/sdb1

# Mount it to a directory
sudo mount /dev/sdb1 /mnt/storage

# Verify
df -h /mnt/storage
```

---

### Network Attached Storage (NAS)

- **NAS** allows data storage over a network, where multiple clients access the shared storage.
- Typically uses protocols like **NFS** (Network File System).
- **Advantages**: Centralized storage, high availability, and supports file-level access.
- **Use Cases**: Ideal for shared repositories, home directories, or file backups.

**Example:**
A NAS device serves a shared directory over the network via NFS. Two clients, `HostA` and `HostB`, can mount and access the same directory.

```bash
# On the NAS server, export the shared directory via NFS
echo "/srv/nas *(rw,sync,no_subtree_check)" >> /etc/exports

# Start the NFS server
sudo exportfs -a
sudo systemctl restart nfs-server

# On the clients (HostA & HostB), mount the NFS share
sudo mount 192.168.1.100:/srv/nas /mnt/nas

# Verify the mount
df -h /mnt/nas
```

---

### Storage Area Network (SAN)

- **SAN** offers block-level storage shared across multiple servers.
- Uses **Fibre Channel (FC)** or **iSCSI** for data transmission, providing low latency and high-speed data access.
- **Advantages**: Ideal for mission-critical applications, databases, and virtual machines (e.g., VMware, Hyper-V).
- **Use Cases**: Highly scalable and suitable for large enterprises needing centralized storage with redundancy.

**Example:**
You set up an iSCSI SAN where `HostA` and `HostB` both access a shared block device over the network. These block devices are treated like locally attached drives on the servers.

```bash
# On the SAN server, configure an iSCSI target
sudo apt install tgt
sudo tgtadm --lld iscsi --op new --mode target --tid 1 -T iqn.2024-09.com.example:storage.target1

# Create a LUN (Logical Unit)
sudo tgtadm --lld iscsi --op new --mode logicalunit --tid 1 --lun 1 -b /dev/sdc

# On the clients, discover and login to the iSCSI target
sudo iscsiadm -m discovery -t st -p 192.168.1.100
sudo iscsiadm -m node --login

# Verify the new block device
lsblk
```

---

## 2. NFS vs SAN

| **Feature**        | **NFS (Network File System)**                              | **SAN (Storage Area Network)**                         |
|--------------------|------------------------------------------------------------|--------------------------------------------------------|
| **Data Access**     | File-level access                                         | Block-level access                                     |
| **Usage**           | Shared file directories, backups, software repositories   | Databases, virtual machines, high-performance workloads|
| **Protocols**       | NFS (over TCP/UDP)                                        | iSCSI, Fibre Channel                                   |
| **Performance**     | Moderate, depends on network                              | High performance, low latency                          |
| **Example**         | Shared repository for multiple servers                    | Shared block device for VM storage                     |

---

## 3. Setting Up LVM (Logical Volume Manager)

**LVM** allows you to manage disk storage flexibly, creating volumes that can be resized dynamically as needed. It abstracts physical storage into logical volumes, making storage management more versatile.

### LVM Workflow:

1. **Initialize the Physical Volume (PV)**:
   First, identify the unused physical disk (e.g., `/dev/sdb`) and initialize it as a PV.

   ```bash
   sudo pvcreate /dev/sdb
   ```

2. **Create a Volume Group (VG)**:
   Combine one or more PVs into a volume group.

   ```bash
   sudo vgcreate storage_vg /dev/sdb
   ```

3. **Create Logical Volumes (LV)**:
   Logical volumes are created from the available space in the volume group.

   ```bash
   sudo lvcreate -L 5G -n data_lv storage_vg
   ```

4. **Create a Filesystem and Mount**:
   Once the LV is created, create a filesystem and mount it.

   ```bash
   sudo mkfs.ext4 /dev/storage_vg-data_lv
   sudo mkdir /mnt/data
   sudo mount /dev/storage_vg-data_lv /mnt/data
   ```

5. **Verify Storage**:
   Check the mounted filesystem using `df`.

   ```bash
   df -h /mnt/data
   ```

### Expanding a Logical Volume:
One of the key advantages of LVM is the ability to resize volumes without downtime.

```bash
# Extend the LV by 2GB
sudo lvextend -L +2G -n /dev/storage_vg/data_lv

# Resize the filesystem to match the new LV size
sudo resize2fs /dev/storage_vg/data_lv
```

---

## 4. Practical Examples and Use Cases

### DAS Setup Example:
You've connected a new SSD to your server and wish to use it as direct-attached storage.

```bash
# List block devices
lsblk

# Create a new partition
sudo fdisk /dev/sdb

# Format the partition as EXT4
sudo mkfs.ext4 /dev/sdb1

# Mount the partition
sudo mount /dev/sdb1 /mnt/das_storage
```

### NAS with NFS Example:
Configure a shared directory using **NFS** on your NAS device that multiple servers can access.

```bash
# On NAS server, install NFS server
sudo apt update && sudo apt install nfs-kernel-server

# Create a shared directory
sudo mkdir -p /srv/shared_data

# Configure NFS to share the directory
echo "/srv/shared_data *(rw,sync,no_root_squash)" | sudo tee -a /etc/exports # send out to terminal and a file

# Restart NFS service to apply changes
sudo exportfs -a && sudo systemctl restart nfs-kernel-server

# On client servers, install NFS client
sudo apt update && sudo apt install nfs-common

# Create a mount point on client
sudo mkdir -p /mnt/nfs_share

# Mount the shared directory from NAS
sudo mount 192.168.10.100:/srv/shared_data /mnt/nfs_share

# Verify the mount
df -h /mnt/nfs_share

```
**Credits**: [Learning Linux Basics Course & Labs](https://learn.kodekloud.com/user/courses/learning-linux-basics-course-labs/)