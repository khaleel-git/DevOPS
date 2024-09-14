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
  ls -lh test.img  # Human-readable size
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

Network Security
IPTABLES and firewalld
chain of rules

iptables -A INPUT -p tcp -s ip --dport 22 -j ACCEPT
-A: Add Rule, -p: Protocol, -s: Source, -d: Destination, --dport: Destination Port, -j Action take
iptables -A INPUT -p tcp --dport 22 -j DROP: reject connection for all other source ips
iptables -L

its top to bottom.

iptables -A INPUT -p tcp --dport 5432 -j ACCEPT