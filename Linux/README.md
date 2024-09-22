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

# List, Set, and Change Standard File Permissions

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
- **rwx** 111 (binary) = 4 + 2 + 1 = **7**
- **rw-** 110 (binary) = 4 + 2 + 0 = **6**
- **r-x** 101 (binary) = 4 + 0 + 1 = **5**

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

# SUID, SGID, and Sticky Bit in Linux

This guide explains the concepts and usage of **SUID**, **SGID**, and **Sticky Bit** in Linux file permissions with practical examples.

## SUID (Set User ID)
SUID allows users to execute a file with the permissions of the file owner. It's most commonly used on executables owned by `root` to allow non-root users to perform tasks that require root privileges.

### How it works:
- SUID is set by adding a `4` to the permissions.
- Only applies to executable files.
- When a user runs the file, it executes with the file owner's permissions.

### Example:
1. **Create a file**:
   ```bash
   touch suidfile
   ls -l suidfile
   # -rw-rw-r-- 1 user user 0 May 8 01:22 suidfile
   ```

2. **Set the SUID bit**:
   ```bash
   chmod 4664 suidfile
   ls -l suidfile
   # -rwSrw-r-- 1 user user 0 May 8 01:22 suidfile  # 'S' indicates SUID is set, but no execute permission
   ```

3. **Set SUID with execute permission**:
   ```bash
   chmod 4764 suidfile
   ls -l suidfile
   # -rwsrw-r-- 1 user user 0 May 8 01:22 suidfile  # 's' indicates SUID with execute permission
   ```

## SGID (Set Group ID)
SGID allows users to execute a file or access a directory with the group permissions of the file's group. It is mostly used on directories, ensuring that files created within inherit the group of the directory.

### How it works:
- SGID is set by adding a `2` to the permissions.
- Files and directories behave differently under SGID.
- On directories, new files inherit the group of the directory, not the creating user's group.

### Example:
1. **Create a file and set SGID**:
   ```bash
   touch sgidfile
   chmod 2674 sgidfile
   ls -l sgidfile
   # -rw-rwsr-- 1 user user 0 May 8 01:25 sgidfile  # 's' indicates SGID is set for the group
   ```

2. **Set SGID on a directory**:
   ```bash
   mkdir sgiddir
   chmod 2775 sgiddir
   ls -ld sgiddir
   # drwxrwsr-x 2 user user 4096 May 8 01:29 sgiddir  # 's' indicates SGID is set on the directory
   ```

### Finding SGID Files:
To find all SGID files in a directory:
```bash
find . -perm /2000
```

## Sticky Bit
The Sticky Bit is mainly used on directories to restrict the deletion or renaming of files by users who do not own the file. Even if a directory is writable, users can only delete their own files.

### How it works:
- Applied on directories to restrict file deletion.
- Often used in shared directories like `/tmp`.

### Example:
1. **Create a directory**:
   ```bash
   mkdir stickydir
   ls -ld stickydir/
   # drwxrwxr-x 2 user user 4096 May 8 01:29 stickydir/
   ```

2. **Set the Sticky Bit**:
   ```bash
   chmod +t stickydir/  # or chmod 1777 stickydir/
   ls -ld stickydir/
   # drwxrwxrwt 2 user user 4096 May 8 01:29 stickydir/  # 't' indicates Sticky Bit is set
   ```

3. **Without Execute Permission**:
   If the directory doesn't have execute permission, you will see a capital `T` instead of `t`:
   ```bash
   chmod 1666 stickydir/
   ls -ld stickydir/
   # drwxrwxrwT 2 user user 4096 May 8 01:29 stickydir/  # 'T' indicates no execute permission
   ```

### Sticky Bit on `/tmp`:
The `/tmp` directory is a good example where the Sticky Bit is set:
```bash
ls -ld /tmp
# drwxrwxrwt 10 root root 4096 May 8 01:29 /tmp
```

### Finding Sticky Bit Directories:
To find directories with the Sticky Bit set:
```bash
find / -type d -perm +1000
```
---

## Finding SUID, SGID, and Sticky Bit Files
The `find` command allows you to search for files based on their permissions. Below are examples for searching files with **SUID**, **SGID**, and **Sticky Bit**.

### 1. Finding SUID Files
Files with the **Set User ID (SUID)** bit allow a user to execute the file with the file owner's privileges.
```bash
find / -perm /4000
```
- **/4000**: Look for files with the SUID bit set.

### 2. Finding SGID Files
Files with the **Set Group ID (SGID)** bit allow users to execute files with the file group’s permissions.
```bash
find / -perm /2000
```
- **/2000**: Search for files with the SGID bit set.

### 3. Finding Sticky Bit Files
The **Sticky Bit** ensures that only the file's owner can delete or modify the file, even if others have write permissions.
```bash
find / -perm /1000
```
- **/1000**: Search for files with the Sticky Bit set.

---

## Using `find` Command for File Search
The `find` command is a powerful tool for locating files and directories based on various criteria.

### 1. Find Files by Name
Search for all `.jpg` files in `/usr/share`.
```bash
find /usr/share -name '*.jpg'
```

### 2. Find Files by Size
Find files larger than 10 MB in `/lib64/`.
```bash
find /lib64/ -size +10M
```
- **+10M**: Search for files larger than 10 MB.

### 3. Find Files Modified Recently
Find files in `/dev/` modified within the last minute.
```bash
find /dev/ -mmin -1
```
- **-mmin**: Search for files modified within the specified number of minutes.

### 4. Case-Sensitive and Case-Insensitive Search
Search for a file named `felix` (case-sensitive):
```bash
find -name felix
```
Search for a file named `felix` (case-insensitive):
```bash
find -iname felix
```

### 5. Wildcard Search
Search for files starting with the letter "f".
```bash
find -name "f*"
```

### 6. Search by Modified Time
Find files modified exactly 5 minutes ago:
```bash
find -mmin 5
```
Find files modified more than 5 minutes ago:
```bash
find -mmin +5
```

### 7. Find Files by Size Range
Search for files with an exact size of 512 KB:
```bash
find -size 512k
```
Find files larger than 512 KB:
```bash
find -size +512k
```
Find files smaller than 512 KB:
```bash
find -size -512k
```

### 8. Combining Multiple Parameters
Search for files starting with "f" and exactly 512 KB in size (AND condition):
```bash
find -name "f*" -size 512k
```
Search for files starting with "f" or with a size of 512 KB (OR condition):
```bash
find -name "f*" -o -size 512k
```

### 9. Exclude Files by Name
Find files that do not begin with "f":
```bash
find -not -name "f*"
```
Alternatively, use the `!` operator:
```bash
find /! -name "f*"
```

---

## Searching by Permissions

### 1. Search by Specific Permissions
Find files with **exactly** 664 permissions:
```bash
find -perm 664
```
- **664**: Owner has read/write, group has read/write, others have read.

### 2. Search by Minimum Permissions
Find files with **at least** 664 permissions:
```bash
find -perm -664
```
- **-664**: Search for files where the permissions include at least 664.

### 3. Search by Any Matching Permissions
Find files with **any** of the 664 permissions:
```bash
find -perm /664
```
- **/664**: Files can have any of these permission bits set.

### 4. Search by Custom Permission Settings
Find files with exactly `rw-rw-r--` permissions:
```bash
find -perm u=rw,g=rw,o=r
```

### 5. Search for Files Accessible Only by Owner
Find files where only the owner has read/write access:
```bash
find -perm 600
```

### 6. Exclude Files with World-Readable Permissions
Find files that are **not** world-readable:
```bash
find \! -perm -o=r
```
- **\! -perm -o=r**: Exclude files with read access for "others."

### Additional examples:
```bash
bob@ubuntu-host ~ ➜  sudo find /var/log/ -perm -g=w ! -perm /o=rw
/var/log/redis
/var/log/nginx
/var/log/httpd

bob@ubuntu-host ~ ➜  sudo find /home/bob/ -size 213k -o -perm 402 > secfile.txt

bob@ubuntu-host ~ ➜  sudo chmod u+s, g+s, o+t
chmod: invalid mode: ‘u+s,’
Try 'chmod --help' for more information.

bob@ubuntu-host ~ ✖ sudo chmod u+s, g+s, o+t datadir/
chmod: invalid mode: ‘u+s,’
Try 'chmod --help' for more information.

bob@ubuntu-host ~ ✖ sudo chmod u+s,g+s,o+t datadir/

bob@ubuntu-host ~ ➜  sudo find /usr/share -name dogs.txt > /home/bob/dogs

bob@ubuntu-host ~ ➜  sudo find /home/bob/ -name cats.txt
sudo cp /home/bob/.etc/h/e/r/cats.txt /opt/cats.txt
/home/bob/.etc/h/e/r/cats.txt

bob@ubuntu-host ~ ➜  sudo find /var/ -type d -name pets > /home/bob/pets.txt

bob@ubuntu-host ~ ➜  sudo find /var -type f -perm 0777 -print

bob@ubuntu-host ~ ➜  sudo find /usr -type f -perm 0640 > /home/bob/.opt/permissions.txt

bob@ubuntu-host ~ ➜  sudo find /usr -type f -mmin -120
/usr/share/games/dogs.txt
/usr/local/test.txt
/usr/games/test2.txt
/usr/games/test.txt
/usr/src/test.txt

bob@ubuntu-host ~ ➜  sudo find /var -type f -mmin -30 | wc -l
40

bob@ubuntu-host ~ ➜  sudo find /var -type f -mmin -30

bob@ubuntu-host ~ ➜  sudo find /var -type f -size 20M

bob@ubuntu-host ~ ➜  sudo find /usr -type f -size +5M -size -10M > /home/bob/size.txt

bob@ubuntu-host ~ ➜  sudo mkdir /home/bob/LFCS
sudo chmod 0100 /home/bob/LFCS

bob@ubuntu-host ~ ➜  chmod 0755 some_directory/
```
# compare and manipulate file content
view, edit, transform , compare text file
cat  file.txt
tac file.txt # read from bottom
tail /var/log/apt/term.log # last 10 lines
tail -n 20 /var/log/apt/term.log # view last 20 lines
head /var/log/apt/term.log # view first 9 lines of text and 1 blank line
head -n 20 /var/log/apt/term.log # view first 20 lines

sed 's/canada/canada/g' userinfo.txt # stream editor, single qoute s:search, g: global, only preview
sed 's/canda/canada/' userinfo.txt # wihout global, only one line, preivew

sed -i 's/canada/canada/g' userinfo.txt --in-place # -i means real change, --in-placye

cut -d ' ' -f 1 userinfo.txt # extract only first row
cut -d ',' -f 3 userinfo > countries.txt # extract 3rd field

uniq countries.txt  # only remove two lines consective to each other
sort countries.txt | uniq # get uniq country list

# compare two files
```bash
diff file1 file2 # identical lines are not showing 
1c1
< only exists in file 1 # < less than means content exists in the first file
---
> only exist in file 2 # > greater than means the content exists in the 2nd file
4c4
< only exist in file 1
---
> only exists in file 2

diff -c file1 file2 # shows us context
diff -y file1 file2  # side by side comparison
sdiff file1 file2 # same as diff -y

## Pagers and VI
less: sudo less /var/log/syslog # bottom left column is the filename, search: /search -> highlight searched word, -i: ignore case, shift+n, press q to quit
more: sudo more /var/log/systlog # more features,  more with percentage, press spacebar, press q key

Vim:
vi improved,
mode sensitive

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

  Search File using grep

grep 'password' /etc/ssh/ssh_config
grep -i 'password' /etc/ssh/sshh_config # case insensitive
grep -r 'password' /etc/ # recursive search in a dir
grep -ri 'password' dir
sudo grep -ri 'password' /etc/ # output is not color coded
sudo grep -ri --color 'password' /etc/ # colored option
sudo -vi 'password' /etc/ssh/sshd_config # inverse search, dont' look for password keyword
grep -wi 'password' /etc/ssh/sshd_config # search complete word match
grep -oi 'password' /etc/ssh/sshd_config # --only-matching option

# Analyze Text Using Basic Regular Expressions
^: carrot, $ dollar sign, .: period, *: asterisk, +: plus, {}: brces, ?: question mark, | vertical pipe, []: bracket, (): prenthesis, square bracket with caroot: [^], #: pound sign

grep '^#' /etc/login.defs # see all comments in a file
grep -v '^#' /etc/login.defs # dont begin with a pound line
grep '^PASS' /etc/login.defs # see lines begin with exact these lines
grep -w '7$' /etc/login.defs # variable 7
grep 'mail$' /etc/login.def  # $ last means end line
^: beginning of the search pattern, $ ends of the search pattern
grep -r 'c.t' /etc/ # find any character in place of dot
grep -wr 'c.t' /etc/
grep '.' /etc/login.def # wont work
grep '\.' /etc/login.def
let* -> letttt....
grep -r '/.*' /etc/ Begins with /: has 0 or more characters between; ends with a/
grep -r '0*' /etc/ # find at leas one zero or multiiple zeroes, also print all lines becasue * print zero times caharacter
0+ -> 00000
grep -r '0+' /etc/ # wont work
grep -r '0\+' /etc/

Extended Regular Expressions
grep -Er '0+' /etc/ -> egrep -r '0+' /etc/
always use egrep
egrep -r '0{3,}' /etc/ # finds 3 or more than 3 zeros
egrep -r '10{,3}' /etc/ # 1 or 
egrep -r '0{3}' /etc/ # find exactly 3 zeros
egrep -r 'disabled?' /etc/ # ? before skip or dont skip (last d is optional)
egrep -r 'enabled|disabled' /etc/ # match enable or disable

[]: Ranges or Sets
egrep -r 'c[au]t' /etc/ # 
[a-z]: matches a to z, [0-9]: matches 0 to 9, [abz954] match in this exact range

egrep -r '/dev/.*' /etc/
egrep -r '/dev/[a-z]*' /etc/
egrep -r '/dev/[a-z]*[0-9]?' /etc
egrep -r '/dev/([a-z]*[0-9]?)*' /etc/
egrep -r '/dev/(([a-z]|[A-Z])*[0-9]?)*' /etc/
egrep -r 'https[^:]' /etc # elements at carot location should not exist
egrep -r 'http[^s]' /etc 
egrep -r '/[^a-z]' /etc