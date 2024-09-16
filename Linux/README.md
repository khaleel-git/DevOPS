# Linux Foundation Certified System Administrator (LFCS) Guide

This guide covers essential Linux commands and concepts for the LFCS exam. Each section provides practical examples for better understanding.

---

## Linux Login, CLI, and GUI

- **Virtual Console**:  
  Use `Ctrl + Alt + F2` to open a virtual terminal (runlevel 3).
  
- **Remote GUI**:  
  Access Linux remotely using VNC or RDP.
  
- **SSH**:  
  Secure Shell is the most commonly used for remote access.  
  Example:
  ```bash
  ssh user@remote_server_ip
  ```

- **View IP Info**:  
  ```bash
  ip a
  ```

- **Check OS Info**:  
  ```bash
  cat /etc/*release*
  ```

---

## System Documentation

- **Get Help**:  
  Use `--help` for quick command options or `man` for detailed documentation.  
  Examples:
  ```bash
  man journalctl
  journalctl --help
  ```
  
- **Search Man Pages**:  
  Use `apropos` to search for related commands.
  ```bash
  apropos hostname
  ```

- **Update Man Page Database**:  
  ```bash
  sudo mandb
  ```

---

## Essential Commands

- **mkdir with parent directory***
  `mkdir -p /tmp/1/2/3/4/5/6/7/8/9`

- **List Files**:
  ```bash
  ls -lah
  ```
  
- **Navigate Directories**:
  ```bash
  cd /    # Root directory
  cd ~    # Home directory
  cd -    # Previous directory
  ```

---

### Links (Hard & Soft Links)

#### Hard Links

- **Create a Hard Link**:  
  Hard links point to the same inode and are only for files.
  ```bash
  ln /path/to/original_file /path/to/hard_link
  ```
  - Example:  
    If `/home/aaron/family_dog.jpg` has 2 hard links and one is deleted, the content remains accessible through the other link.
  
- **Limitations**:
  - Only for files (no directories).
  - Can't span across different filesystems.

#### Soft Links (Symbolic Links)

- **Create a Soft Link**:  
  Soft links are shortcuts, and they can link files or directories across filesystems.
  ```bash
  ln -s /path/to/original /path/to/shortcut
  ```
  
- **View Soft Links**:  
  The path of the original file is stored in the symbolic link:
  ```bash
  ls -l
  ```
  - Output:
    ```bash
    lrwxrwxrwx. 1 user family_dog_shortcut.jpg -> /home/aaron/Pictures/family_dog.jpg
    ```
---

## System Monitoring

- **View System Logs**:
  ```bash
  journalctl
  ```

- **View Active Processes**:
  ```bash
  top
  ```

- **Check Disk Usage**:
  ```bash
  df -h
  ```
---

 ## users and groups
 chgrp group_name file/directory
 groups
 chown (owner) only root user can change the owner of a file - `sudo chown jane file.txt`

 ## File and Directory Permission
 d (Directory)
 - (Regular File)
 c (character device)
 | (link)
 p pipe
 s (socket file)
 b (block device)

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

```bash
chmod g=r file.txt
chmod g=rw file.txt
chmod g=   file.txt
chmod u+rw,g=r,0= family_dog.jpg
```

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