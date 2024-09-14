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

Here's a dedicated `README.md` file for the Linux accounts section with detailed information and examples:

```markdown
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
