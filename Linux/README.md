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
 ```shell
 chgrp group_name file/directory
 groups # list all grops
 chown (owner) only root user can change the owner of a file - `sudo chown jane file.txt`
 ```

 ## File and Directory Permission
 ```shell
 d (Directory)
 - (Regular File)
 c (character device)
 | (link)
 p pipe
 s (socket file)
 b (block device)
 ```

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

# SUID (Set User ID), SGID, and Sticky Bit in Linux

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

### Finding SUID Files:
To find all SUID (Set User ID) files in a directory:

```bash
find . -perm /4000
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

# Compare and Manipulate File Content
## Viewing File Content
### 1. Display the Entire File
To display the entire content of a file:
```bash
cat file.txt
```

### 2. Display the Content in Reverse Order
To display the content of a file from bottom to top:
```bash
tac file.txt
```

### 3. View the Last Few Lines of a File
To display the last 10 lines of a file:
```bash
tail /var/log/apt/term.log
```

To display the last 20 lines of a file:
```bash
tail -n 20 /var/log/apt/term.log
```

### 4. View the First Few Lines of a File
To display the first 10 lines of a file (including 1 blank line):
```bash
head /var/log/apt/term.log
```

To display the first 20 lines of a file:
```bash
head -n 20 /var/log/apt/term.log
```

## Editing and Transforming File Content with `sed`

`sed` (stream editor) is a powerful tool for making transformations on text data in a stream (such as modifying a file on the fly).

### 1. Search and Replace Using `sed`
- **Global Replacement (`g` flag) vs Simple Replacement (No `g` flag):**

  - **Global replacement** (`g` flag) searches and replaces **all occurrences** of a pattern in each line.
    Example: Replace all occurrences of "canada" with "Canada" in each line:
    ```bash
    sed 's/canada/Canada/g' userinfo.txt
    ```

  - **Simple replacement** (without `g`) only replaces the **first occurrence** of the pattern in each line.
    Example: Replace only the first occurrence of "canda" with "Canada" in each line:
    ```bash
    sed 's/canda/Canada/' userinfo.txt
    ```

- **Apply changes directly to the file:**
  - To make in-place changes (modify the actual file):
    ```bash
    sed -i 's/canada/Canada/g' userinfo.txt
    ```

  The `-i` option means in-place, meaning that the file will be directly modified with the changes, without needing to redirect the output to another file.

## Extracting Fields from a File (CUT)

### 1. Extract Specific Fields Using `cut`
- Extract the first column (field) from `userinfo.txt`, assuming fields are space-separated:
  ```bash
  cut -d ' ' -f 1 userinfo.txt
  ```

- Extract the third field from `userinfo.txt` where fields are separated by commas, and save the output to `countries.txt`:
  ```bash
  cut -d ',' -f 3 userinfo.txt > countries.txt
  ```

## Sorting and Removing Duplicates with `uniq` and `sort`

### 1. Remove Consecutive Duplicate Lines Using `uniq`
- **Important note**: `uniq` only removes **consecutive duplicate lines**. It will not remove non-consecutive duplicates unless the file is first sorted.

  - Example: To remove consecutive duplicate lines in `countries.txt`:
    ```bash
    uniq countries.txt
    ```

### 2. Sort and Remove All Duplicates
- To remove **all** duplicates (even non-consecutive ones), sort the file first and then use `uniq`:
  ```bash
  sort countries.txt | uniq
  ```

In this case, `sort` ensures that duplicates are next to each other, allowing `uniq` to remove all of them effectively.

## Comparing Files

You can compare the contents of two files using the `diff` command.

### 1. Compare Two Files Line-by-Line
```bash
diff file1 file2
```

- `<` indicates content that is only in `file1`.
- `>` indicates content that is only in `file2`.

### 2. Show Context for Differences
To show additional context around the differences, use the `-c` flag:
```bash
diff -c file1 file2
```

### 3. Side-by-Side Comparison
To display a side-by-side comparison:
```bash
diff -y file1 file2
```

Or use `sdiff` for a similar side-by-side comparison:
```bash
sdiff file1 file2
```

# Pagers in Linux (less & more)

Pagers are command-line utilities used to view the contents of text files or command output one screen at a time. The most common pagers are `less` and `more`. This document will explain the differences between them and provide usage examples.


## What is `less`?

`less` is a modern pager that allows for both forward and backward navigation through text files. It provides more features than `more`, making it a preferred choice for many users.

### Features of `less`:
- Scroll up and down through content.
- Search for text patterns.
- Display line numbers.
- Support for viewing compressed files.

## What is `more`?

`more` is an older pager that allows users to view text files one screen at a time, primarily designed for forward navigation. Once you reach the end of the output, you cannot scroll back.

### Features of `more`:
- Simple forward scrolling.
- Basic searching capabilities.
- Limited navigation (no backward scrolling).

## Comparison of `less` and `more`

| Feature              | less                | more                  |
|----------------------|---------------------|-----------------------|
| Forward Navigation   | Yes                 | Yes                   |
| Backward Navigation  | Yes                 | No                    |
| Searching            | Yes                 | Limited               |
| Display Line Numbers | Yes                 | No                    |
| Compression Support  | Yes                 | No                    |

## Examples

### Using `less`

1. To view a file:
   ```bash
   less filename.txt
   ```
2. To search for a term (press `/` followed by the term):
   ```bash
   /search_term
   ```
3. To scroll down, press the space bar or the `↓` arrow. To scroll up, press `b` or the `↑` arrow.

### Using `more`

1. To view a file:
   ```bash
   more filename.txt
   ```
2. To search for a term (press `/` followed by the term):
   ```bash
   /search_term
   ```
3. To scroll down, press the space bar. To exit, press `q`.


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

# grep Command

## Common Options

- `-i`: Ignore case distinctions in both the pattern and input files.
- `-r`: Recursively search directories.
- `-w`: Match whole words only.
- `-o`: Show only the matching part of a line.
- `-v`: Invert the match, showing lines that do not match the pattern.
- `--color`: Highlight matching strings in color for better visibility.

## Examples

### 1. Search for a Keyword in a File

To search for the keyword "password" in the SSH configuration file:

```bash
grep 'password' /etc/ssh/ssh_config
```

### 2. Case-Insensitive Search

To perform a case-insensitive search for "password":

```bash
grep -i 'password' /etc/ssh/ssh_config
```

### 3. Recursive Search in a Directory

To search for "password" in all files within the `/etc/` directory and its subdirectories:

```bash
grep -r 'password' /etc/
```

### 4. Recursive Search in a Specified Directory

To recursively search for "password" in a directory named `dir`:

```bash
grep -ri 'password' /dir
```

### 5. Searching with Elevated Permissions

To search for "password" recursively in `/etc/`, using `sudo` for permissions:

```bash
sudo grep -ri 'password' /etc/
```

### 6. Output with Color Coding

To enable color-coded output while searching for "password":

```bash
sudo grep -ri --color 'password' /etc/
```

### 7. Inverse Search (Excluding a Keyword)

To show lines that do not contain the keyword "password" in the SSH daemon configuration:

```bash
sudo grep -vi 'password' /etc/ssh/sshd_config
```

### 8. Whole Word Match

To search for "password" as a complete word in the SSH daemon configuration:

```bash
grep -wi 'password' /etc/ssh/sshd_config
```

### 9. Show Only Matching Parts

To display only the matching part of the lines that contain "password":

```bash
grep -oi 'password' /etc/ssh/sshd_config
```

# Analyzing Text Using Regular Expressions

Regular expressions (regex) are powerful tools for searching and manipulating text. They allow for sophisticated pattern matching, making it easier to analyze and extract information from files.

### Common Basic Regex Patterns
- `^`: Matches the beginning of a line.
- `$`: Matches the end of a line.
- `.`: Matches any single character.
- `*`: Matches zero or more occurrences of the preceding element.
- `+`: Matches one or more occurrences of the preceding element.
- `{}`: Matches a specific number of occurrences.
- `?`: Matches zero or one occurrence of the preceding element.
- `|`: Acts as a logical OR.
- `[]`: Matches any one of the enclosed characters.
- `()`: Groups patterns.
- `[^]`: Matches any character not in the brackets.
- `#`: Used to denote comments (in certain contexts).

### Examples of Basic Regular Expressions
1. **See All Comments in a File**
   ```bash
   grep '^#' /etc/login.defs
   ```

2. **Exclude Lines Starting with a Pound Sign**
   ```bash
   grep -v '^#' /etc/login.defs
   ```

3. **Lines Beginning with "PASS"**
   ```bash
   grep '^PASS' /etc/login.defs
   ```

4. **Lines Ending with the Number 7**
   ```bash
   grep -w '7$' /etc/login.defs
   ```

5. **Finding Any Character in Place of a Dot**
   ```bash
   grep -r 'c.t' /etc/
   ```

6. **Escape the Dot to Match a Literal Period**
   ```bash
   grep '\.' /etc/login.defs
   ```

7. **Matching Lines Starting with a Slash and Ending with a Slash**
   ```bash
   grep -r '/.*' /etc/
   ```

8. **Finding Lines with Zero or More Zeros**
   ```bash
   grep -r '0*' /etc/  # Matches all lines because * can match zero occurrences.
   ```

9. **Finding Lines with One or More Zeros**
   ```bash
   grep -r '0\+' /etc/
   ```

## Extended Regular Expressions
Extended regular expressions (ERE) allow for more advanced pattern matching capabilities compared to basic regex.
### Common Extended Regex Patterns

- `+`: Matches one or more occurrences.
- `?`: Matches zero or one occurrence, with the preceding character being optional.
- `{n,m}`: Matches between `n` and `m` occurrences.
- `|`: Acts as a logical OR.

### Examples of Extended Regular Expressions
1. **Using Egrep for One or More Zeros**
   ```bash
   egrep -r '0+' /etc/
   ```

2. **Finding Three or More Zeros**
   ```bash
   egrep -r '0{3,}' /etc/
   ```

3. **To find lines that contain "1" followed by one or two "0"s, you would use:**
   ```bash
   egrep -r '10{1,2}' /etc/
   ```

4. **Finding Exactly Three Zeros**
   ```bash
   egrep -r '0{3}' /etc/
   ```

5. **Optional Last Character**
   ```bash
   egrep -r 'disabled?' /etc/
   ```

6. **Match "enabled" or "disabled"**
   ```bash
   egrep -r 'enabled|disabled' /etc/
   ```

7. **Character Ranges or Sets**
   ```bash
   egrep -r 'c[au]t' /etc/
   ```

8. **Matching Paths with Specific Patterns**
   ```bash
   egrep -r '/dev/.*' /etc/
   egrep -r '/dev/[a-z]*' /etc/
   egrep -r '/dev/[a-z]*[0-9]?' /etc/
   egrep -r '/dev/([a-z]*[0-9]?)*' /etc/
   egrep -r '/dev/(([a-z]|[A-Z])*[0-9]?)*' /etc/
   ```

9. **Excluding Certain Characters**
   ```bash
   egrep -r 'https[^:]' /etc/
   egrep -r 'http[^s]' /etc/
   egrep -r '/[^a-z]' /etc/
   ```

---

## Archive, Back Up, Compress, Unpack, and Uncompress Files

### Archiving with tar

The `tar` command is used to create and manage archive files. Below are common usage examples:

#### Create an Archive

```bash
tar --create --file archive.tar file1
# Equivalent to:
tar cf archive.tar file1
```

#### Append to an Existing Archive

```bash
tar --append --file archive.tar file2
# Equivalent to:
tar rf archive.tar file2
```

#### List Archive Contents

Before unarchiving, you can list the contents of an archive:

```bash
tar --list --file archive.tar
# Equivalent to:
tar tf archive.tar
```

#### Unarchiving

To extract files from an archive:

```bash
tar --extract --file archive.tar
# Equivalent to:
tar xf archive.tar
# By default, it extracts to the current directory.
```

To extract to a different directory:

```bash
tar --extract --file archive.tar --directory /tmp/
# Equivalent to:
tar xf archive.tar -C /tmp/
```

### Compressing and Uncompressing Files

Various tools can be used for file compression:

- **Compress**: `gzip`, `bzip2`, `xz`
- **Uncompress**: `gunzip`, `bunzip`, `unxz`

#### Keeping Original Files

To keep the original files while compressing:

```bash
gzip --keep file1
bzip2 --keep file2
xz --keep file3
```

#### Listing Compressed Files

To list files compressed with `gzip`:

```bash
gzip --list file1
```

#### Using zip

To create a zip archive:

```bash
zip archive.zip file1
```

To recursively compress all files in a directory:

```bash
zip -r archive.zip Pictures
```

To unzip an archive:

```bash
unzip archive.zip
```

### Note on Zip

Unlike `tar`, `zip` supports both packing and compression in one step. This can simplify workflows:

- **Using zip** eliminates the need to first pack with `tar` and then compress with `gzip`.

---

### Backing Up Files to a Remote System

You can use `rsync` for efficient file transfer and synchronization. Ensure the SSH daemon is running for remote transfers:

```bash
# Local to remote
rsync local remote

# Local to local
rsync local local
```

---

### Disk Imaging

To create a disk image, use `dd`:

```bash
sudo dd if=/dev/vda of=diskimage.raw bs=1M status=progress
```

- `if`: Input file (the source device)
- `of`: Output file (the disk image)
- `bs`: Block size

#### Restoring from a Disk Image

To restore a disk image, reverse the `if` and `of` options:

```bash
sudo dd if=diskimage.raw of=/dev/vda bs=1M status=progress
```

---

### Input-Output Redirection

You can use redirection to control where command output goes:

- `>`: Redirect stdout to a file.
- `>>`: Append stdout to a file.
- `|`: Pipe output of one command as input to another.
- `2>`: Redirect stderr to a file.

#### Examples

To sort a file and redirect output:

```bash
sort file.txt > sorted.txt
# or
sort file.txt 1> sorted.txt
```

- `1>` refers to stdout.
- `2>` refers to stderr.

To discard errors:

```bash
2> /dev/null
```

To capture both output and errors:

```bash
grep -r '^The' /etc/ > all_output.txt 2>&1
```

---

### Here Documents

A Here Document (heredoc) allows you to provide input to commands:

```bash
sort <<EOF
6
4
2
1
4
EOF
```
### Sorting and Formatting Output

To filter, sort, and format output from a file:

```bash
grep -v '^#' /etc/login.defs | sort | column -t
```

## Working With SSL Certificates

### Overview

- **SSL (Secure Sockets Layer)**: An older protocol for securing communications over a network.
- **TLS (Transport Layer Security)**: The latest version of SSL, though many still refer to it as SSL.

### OpenSSL

OpenSSL is a robust tool for creating and managing SSL/TLS certificates. You can access help with:

```bash
openssl help
```

### Certificate Signing Request (CSR)

To create a valid SSL certificate, a Certificate Signing Request (CSR) is necessary. This request is sent to a Certificate Authority (CA), which signs it. Common CAs include Google and Let's Encrypt.

### Generate a Certificate

To generate a new certificate and private key, use the following commands:

```bash
openssl req -newkey rsa:2048 -keyout priv.key -out certificate.crt
openssl x509 -in certificate.crt -text
```

### Self-Signed Certificate

To create a self-signed certificate, use the following command:

```bash
openssl req -x509 -nodes -days 365 -keyout priv.key -out kodekloud.crt
```

---

## Git - Basic Operations

### Configuration

Set your global username and email for Git:

```bash
git config --global user.name "jeremy"
git config --global user.email "myemail@domain.com"
```

### Basic Commands

- Check the status of your repository:
  ```bash
  git status
  ```
- Add files to the staging area:
  ```bash
  git add file1 file2
  git add "*.html"
  git add "products/*.html"
  git add products/
  ```
- Remove a file from the staging area:
  ```bash
  git reset file2
  git reset products/
  ```
- Commit your changes:
  ```bash
  git commit -m "message"
  ```

### Dealing with Bugs

To address bugs in your code:

```bash
git add file3
git commit -m "new bug"
git rm file3 # remove a file from the working area
```

### Git Branches

Branches allow you to work on multiple versions of a project simultaneously:

- Create a new branch:
  ```bash
  git branch 1.1-testing
  ```
- List branches:
  ```bash
  git branch --list
  git branch
  ```
- Switch to a branch:
  ```bash
  git checkout 1.1-testing
  ```

### Merging Branches

To merge branches into the master branch:

```bash
git merge 1.1-testing
```

### Remote Repository Operations

- Check remote URLs:
  ```bash
  git remote -v
  ```
- Add a new remote:
  ```bash
  git remote add origin <url>
  ```
- Push changes to the remote repository:
  ```bash
  git push origin master
  ```
- Pull updates from the remote repository:
  ```bash
  git pull origin master
  ```
- Clone a repository:
  ```bash
  git clone <url>
  ```
---
## Boot, Reboot, and Shutdown a System Safely

To reboot or shut down your system, use the following commands:

- **Reboot the system:**
  - If you are the root user:
    ```bash
    systemctl reboot
    ```
  - If you are a regular user:
    ```bash
    sudo systemctl reboot
    ```
  - To force reboot:
    ```bash
    sudo systemctl reboot --force
    ```

- **Power off the system:**
  ```bash
  sudo systemctl poweroff --force
  ```

- **Scheduled shutdowns:**
  ```bash
  sudo shutdown 02:00
  sudo shutdown +15  # Shutdown in 15 minutes
  sudo shutdown -r +15  # Reboot in 15 minutes
  sudo shutdown -r +1 "Scheduled restart to upgrade our Linux Kernel"  # Message to wall
  ```

---

## Boot or Change System Into Different Operating Modes

Change system operating modes with the following commands:

- **Check current default target:**
  ```bash
  systemctl get-default  # e.g., graphical.target
  ```

- **Set the default target to text-based:**
  ```bash
  sudo systemctl set-default multi-user.target
  ```

- **Isolate a target temporarily:**
  ```bash
  sudo systemctl isolate graphical.target  # Does not change the default target
  ```

- **Access emergency and rescue modes:**
  - Emergency mode:
    ```bash
    emergency.target  # Minimal environment, read-only root filesystem
    ```
  - Rescue mode:
    ```bash
    rescue.target  # Fewer programs than emergency mode
    ```

---

## Use Scripting to Automate System Maintenance Tasks

You can automate system tasks using bash scripts. Here’s how to create and run a simple script:

1. **Create a script file:**
   ```bash
   touch script.sh
   ```

2. **Add commands to the script:**
   ```bash
   #!/bin/bash
   date >> /tmp/script.log
   cat /proc/version >> /tmp/script.log  # Check kernel version
   ```

3. **Make the script executable:**
   ```bash
   chmod +x script.sh
   ```

4. **Run the script:**
   ```bash
   ./script.sh  # or sh script.sh
   ```

Here’s an example of a more complex script that handles an archive:

```bash
#!/bin/bash

if test -f /tmp/archive.tar.gz; then
  mv /tmp/archive.tar.gz /etc/apt/
  tar acf /tmp/archive.tar.gz /etc/apt/
else
  tar acf /tmp/archive.tar.gz /etc/apt/
fi
```

- **Exit statuses:**
  - `exit status = 0` indicates success (true).
  - `exit status > 0` indicates failure (false).

---

## Manage Startup Process and Services

### Service Management in Linux

`systemd` is a system and service manager for Linux that controls the startup of applications and services. The main commands used are:

- **View service configuration:**
  ```bash
  systemctl cat ssh.service
  ```

- **Edit service:**
  ```bash
  sudo systemctl edit --full ssh.service
  ```

- **Check service status:**
  ```bash
  sudo systemctl status ssh.service
  ```

- **Start, stop, or restart a service:**
  ```bash
  sudo systemctl stop ssh.service
  sudo systemctl start ssh.service
  sudo systemctl restart ssh.service  # Note: May interrupt existing connections
  ```

- **Enable or disable services:**
  ```bash
  sudo systemctl enable ssh.service   # Enable at boot
  sudo systemctl disable ssh.service  # Disable auto-start
  ```

- **Mask or unmask a service:**
  ```bash
  sudo systemctl mask atd.service     # Prevent the service from running
  sudo systemctl unmask atd.service   # Re-enable the service
  ```

- **List all services:**
  ```bash
  sudo systemctl list-units --type service --all
  ```

---

## Create systemd Services

### Creating a New Service

1. **Create a script for your service:**
   ```bash
   sudo vi /usr/local/bin/myapp.sh
   ```

   Example content:
   ```bash
   #!/bin/bash
   echo "MyApp Started" | systemd-cat -t MyApp -p info
   sleep 5
   echo "MyApp Crashed" | systemd-cat -t MyApp -p err
   ```

2. **Copy an existing service template:**
   ```bash
   sudo cp /lib/systemd/system/ssh.service /etc/systemd/system/myapp.service
   ```

3. **Define the service in the unit file:**
   ```ini
   [Unit]
   Description=My Custom Application

   [Service]
   ExecStart=/bin/bash /usr/local/bin/myapp.sh

   [Install]
   WantedBy=multi-user.target
   ```

4. **Reload systemd and start your service:**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl start myapp.service
   ```

---

## Common systemctl Commands

### Manage Services
- Start, stop, restart, and reload services:
  ```bash
  systemctl start docker
  systemctl stop docker
  systemctl restart docker
  systemctl reload docker
  ```

### Enable/Disable Services
- Manage service autostart:
  ```bash
  systemctl enable docker
  systemctl disable docker
  ```

### Check Service Status
- View service status:
  ```bash
  systemctl status docker
  ```

### Reload systemd
- After making changes:
  ```bash
  systemctl daemon-reload
  ```

### Edit Service Unit Files
- Modify service configurations:
  ```bash
  systemctl edit project.service --full
  ```

### Manage Targets
- Set the system run-level:
  ```bash
  systemctl get-default
  systemctl set-default multi-user.target
  ```

### List All Units
- Display available systemd units:
  ```bash
  systemctl list-units --all
  ```
---
# Diagnose and Manage Processes
### Comparing `ps` Options

- **`ps -a` vs `ps a`**: These options are not equivalent. The following command outputs the number of processes listed by each:

    ```bash
    ❯ ps -a | wc -l
    20
    ❯ ps a | wc -l
    27
    ```

- **`ps`**: Displays processes for the current terminal session.
  
- **`ps aux`**: 
  - `a`: Show processes for all users.
  - `u`: Display in a user-oriented format, including useful columns like memory and CPU usage, along with the user each process belongs to.
  - Kernel processes are often shown in brackets `[]`.

### Real-time Process Monitoring

- **`top`**: Provides real-time information about system processes, focusing on CPU-intensive processes.

### Specific Process Information

- **`ps <pid>`**: Displays information about a specific process by its PID. For example, `ps 123` or `ps u 123` for user-oriented details.
  
- **`ps -U <username>`**: Shows processes belonging to a specific user, e.g., `ps -U jeremy`.

- **`pgrep -a syslog`**: Lists processes matching the name `syslog` along with their arguments.

### Process Priority Management

- **Nice Value**: A process's priority can be adjusted using the nice value. The command format is:

    ```bash
    nice -n [NICE VALUE] [COMMAND]
    ```
    
  Example: To start a new shell with a nice value of 11:

    ```bash
    nice -n 11 bash
    ```

- **Displaying Nice Values**:
    - **`ps l`**: Shows the nice values in the `NI` column.
    - **`ps aux`**: Displays all processes with detailed information.
    - **`ps faux`**: Displays a hierarchical view of processes.

### Nice Value Limitations

- Regular users can assign nice values between 0 and 19.
- To assign a higher priority (lower nice value), root privileges are required:

    ```bash
    sudo nice -n -12 bash
    ```

- To change the nice value of an existing process (using PID):

    ```bash
    bash
    ps fax   # Get the PID
    renice 7 <pid>
    ```

### Important Notes

- Regular users cannot lower the nice value; they can only increase it (make the process "nicer").
- To lower the nice value, root privileges are necessary.
---
## Signals
### Process Control Commands

- **Stop and Kill Processes:**
  - `sygstop`: Stop a process (if available; note that the correct command is usually `kill -SIGSTOP <PID>`).
  - `syskill`: Forcefully kill a process (note that the correct command is usually `kill -9 <PID>`).
  - `kill -L`: List all signal names.
  
- **Check SSH Service Status:**
  - `systemctl status sshd.service`: Check the status of the SSH daemon.

- **Send Signals to Processes:**
  - `kill -SIGHUP <PID>`: Send a hangup signal (to restart the process).
  - `kill -KILL <PID>`: Forcefully terminate a process.
  - `pkill <process_name>`: Kill all processes matching the name.
  - `pgrep -a <process_name>`: List processes matching the name with arguments.
  - `lsof -p <PID>`: Show all open files for the specified process.
  - `sudo lsof -p <PID>`: Show all open files for the specified process with superuser privileges.
  
### Background and Foreground Jobs

- **Controlling Jobs:**
  - `sleep 180`: Run a command for a specified duration (in this case, 180 seconds).
  - `Ctrl + C`: Interrupt a running process (note: may not work for all processes).
  - `Ctrl + Z`: Pause a process and put it in the background (note: may not work for all processes).
  - `fg`: Bring a background process back to the foreground.
  - `jobs`: List all background jobs.
  - `bg <job_id>`: Resume a suspended job in the background.
  
- **Examples:**
  - `sleep 300 &`: Run the sleep command in the background.
  - `fg 1`: Bring the job with ID 1 back to the foreground.
  - `bg 1`: Resume the job with ID 1 in the background.
  
### File and Directory Management

- **Check Open Files:**
  - `lsof /var/log/auth.log`: Show open files for the specified log file.
  - `sudo lsof /var/log/auth.log`: Show open files for the specified log file with superuser privileges.

### Notes

- Be cautious when using commands that can terminate processes (`kill`, `pkill`, etc.), as they can lead to data loss or system instability.
- Not all commands may work with every process due to permissions and the nature of the command.

---
## Locate and Analyze System Log Files
### Locating Log Files
Log files are usually stored in the `/var/log/` directory. To view the contents of this directory, use:

```bash
ls /var/log/
```

Example output:
```
auth.log       syslog          kern.log        dpkg.log
```

### Analyzing Log Files
You can examine specific log files using tools like `grep`, `less`, and `tail`. For example:

1. **View SSH-related logs**:
   ```bash
   grep -r 'ssh' /var/log/
   ```

2. **View authentication logs**:
   ```bash
   less /var/log/auth.log
   ```

3. **View system logs**:
   ```bash
   less /var/log/syslog
   ```

4. **Follow live updates to the authentication log**:
   ```bash
   tail -F /var/log/auth.log
   ```

### Using Journalctl
`journalctl` is a powerful tool for querying system logs managed by `systemd`. Here are some common usages:

- **View logs for a specific service**:
  ```bash
  journalctl -u ssh.service
  ```

- **View all logs**:
  ```bash
  journalctl
  ```

- **Live view of logs**:
  ```bash
  journalctl -f
  ```

- **Filter logs by priority**:
  ```bash
  journalctl -p err
  ```

- **View logs from a specific time range**:
  ```bash
  journalctl -S '2024-03-03 01:00' -U '2024-03-03 02:00'
  ```

- **Group logs by boot**:
  ```bash
  journalctl -b 0   # Current boot
  journalctl -b -1  # Previous boot
  ```

### Checking User Login History
To see who has logged into the system and when, you can use:

- **Last login details**:
  ```bash
  last
  ```

- **Last login information for each user**:
  ```bash
  lastlog
  ```

### Examples and Demo Output
Here are some example commands and their expected output:

1. **List log files**:
   ```bash
   ls /var/log/
   ```
   Output:
   ```
   auth.log       syslog          kern.log        dpkg.log
   ```

2. **View the last 10 lines of the auth log**:
   ```bash
   tail /var/log/auth.log
   ```
   Output (example):
   ```
   Sep 24 12:00:00 hostname sshd[1234]: Accepted password for user from 192.168.1.1 port 22
   Sep 24 12:01:00 hostname sshd[1234]: Disconnecting: 2: Too many authentication failures
   ```

3. **Filter for errors**:
   ```bash
   journalctl -p err
   ```
   Output (example):
   ```
   Sep 24 12:02:00 hostname systemd[1]: Failed to start My Service.
   ```

4. **Check who is logged in**:
   ```bash
   last
   ```
   Output (example):
   ```
   user    pts/0        192.168.1.1      Mon Sep 24 12:00   still logged in
   ```

5. **View logs for SSH service**:
   ```bash
   journalctl -u ssh.service
   ```
   Output (example):
   ```
   Sep 24 12:00:00 hostname systemd[1]: Starting OpenSSH server daemon...
   Sep 24 12:00:01 hostname sshd[1234]: Server listening on 0.0.0.0 port 22.
   ```
---  
# Cronjobs, Anacron, and At

## Cronjobs

**Cron** is a time-based job scheduler in Unix-like operating systems. Cronjobs allow you to run commands or scripts at specific intervals.

### Cron Syntax

The syntax for a cronjob consists of five fields followed by the command to be executed:

```
m h dom mon dow command
```

- **m**: Minute (0 - 59)
- **h**: Hour (0 - 23)
- **dom**: Day of the month (1 - 31)
- **mon**: Month (1 - 12)
- **dow**: Day of the week (0 - 7) (Sunday = 0 or 7)

### Examples

- **08:10 AM on 19th February, Monday**
    ```bash
    10 8 19 2 1 command
    ```

- **08:10 AM on 19th February, Any Weekday**
    ```bash
    10 8 19 2 * command
    ```

- **08:10 AM on 19th of Every Month, Any Weekday**
    ```bash
    10 8 19 * * command
    ```

- **08:10 AM Every Day of Every Month, Any Weekday**
    ```bash
    10 8 * * * command
    ```

- **10th Minute of Every Hour, Every Day, Every Month, Any Weekday**
    ```bash
    10 * * * * command
    ```

- **Every Minute of Every Hour, Every Day, Every Month, Any Weekday**
    ```bash
    * * * * * command
    ```

- **Every 2 Minutes of Every Hour, Every Day, Every Month, Any Weekday**
    ```bash
    */2 * * * * command
    ```

- **Every Day at 9 PM**
    ```bash
    0 21 * * * command
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

### Special Directories
Cron can also manage jobs using special directories:
- `daily` = `/etc/cron.daily/`
- `hourly` = `/etc/cron.hourly/`
- `monthly` = `/etc/cron.monthly/`
- `weekly` = `/etc/cron.weekly/`

To add a script to the hourly jobs:
```bash
touch shellscript
sudo cp shellscript /etc/cron.hourly/shellscript
sudo chmod +rx /etc/cron.hourly/shellscript
```

---

## Anacron

**Anacron** is similar to cron, but is used for running commands on a regular basis with the guarantee that they will be run at least once, even if the machine is not running at the scheduled time.

### Managing Anacron Jobs

Edit the Anacron configuration file:
```bash
sudo vim /etc/anacrontab
```

To run Anacron:
```bash
anacron -T
```

---

## At

**At** is a utility that allows you to schedule a command to be run once at a particular time.

### Using At

- **Schedule a command for a specific time:**
    ```bash
    at '15:00'
    at> /usr/bin/touch file
    Ctrl + D  # Save
    ```

- **Schedule a command for a specific date:**
    ```bash
    at '2:30 August 20 2024'
    ```

- **Schedule a command relative to the current time:**
    ```bash
    at 'now + 30 minutes'
    at 'now + 3 hours'
    ```

### Managing At Jobs

- **List scheduled jobs:**
    ```bash
    atq
    ```

- **View a specific job:**
    ```bash
    at -c job_number
    ```

- **Remove a scheduled job:**
    ```bash
    atrm job_number
    ```
---
## APT: Advanced Package Tool
### Basic APT Commands

These commands are essential for managing packages:

- **Update Package Lists**
  ```bash
  sudo apt update
  ```
  Updates the package lists from the repositories.

- **Upgrade Installed Packages**
  ```bash
  sudo apt upgrade
  ```
  Upgrades all installed packages to their latest versions.

- **Install a Package (e.g., Nginx)**
  ```bash
  sudo apt install nginx
  ```
  Installs the Nginx web server and any necessary dependencies.

- **List Files in a Package**
  ```bash
  dpkg --listfiles nginx
  ```
  Displays all files installed by the Nginx package.

- **Search for a File in a Package**
  ```bash
  dpkg --search /usr/sbin/nginx
  ```
  Identifies which package installed the specified file.

- **Show Package Details**
  ```bash
  apt show libnginx-mod-stream
  ```
  Provides detailed information about a specific package.

- **Search for Packages**
  ```bash
  apt search nginx
  ```
  Searches for packages related to Nginx.

- **Remove a Package**
  ```bash
  sudo apt remove nginx
  ```
  Uninstalls the Nginx package.

- **Auto-remove Unused Dependencies**
  ```bash
  sudo apt autoremove
  ```
  Removes packages that were automatically installed as dependencies but are no longer needed.

---

### Managing Repositories

APT uses repositories to manage software. Repository configurations are typically found in `/etc/apt/sources.list` or `/etc/apt/sources.list.d/`.

#### Example of Repository Configuration
```plaintext
deb https://us.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse
```
- **deb**: Indicates a binary package repository.
- **https://us.archive.ubuntu.com/ubuntu/**: URL of the repository.
- **focal**: The release name (e.g., for Ubuntu 20.04).
- **main restricted universe multiverse**: Components of the repository.

---

### Adding 3rd Party Repositories

To add a third-party repository, follow these steps:

1. **Download the Public Key**
   ```bash
   curl -fsSL https://example.com/repo-key.gpg -o repo-key.gpg
   ```

2. **Add the Key to Your Keyring**
   ```bash
   gpg --dearmor repo-key.gpg
   sudo mv repo-key.gpg /etc/apt/trusted.gpg.d/
   ```

3. **Add the Repository**
   ```bash
   echo "deb [signed-by=/etc/apt/trusted.gpg.d/repo-key.gpg] https://example.com/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/example.list
   ```

4. **Update APT**
   ```bash
   sudo apt update
   ```

---

### Using Personal Package Archives (PPA)

PPAs are a convenient way to install software from third-party developers.

- **Add a PPA**
  ```bash
  sudo add-apt-repository ppa:graphics-drivers/ppa
  ```

- **List Added PPAs**
  ```bash
  ls /etc/apt/sources.list.d/
  ```

- **Remove a PPA**
  ```bash
  sudo add-apt-repository --remove ppa:graphics-drivers/ppa
  ```

---

### Installing Software from Source

To install software not available in the repositories, you can compile it from source:

1. **Clone the Repository**
   ```bash
   git clone https://github.com/hishamhm/htop.git
   cd htop
   ```

2. **Install Dependencies**
   ```bash
   sudo apt install libncursesw5-dev autotools-dev autoconf automake build-essential
   ```

3. **Compile the Software**
   ```bash
   ./autogen.sh
   ./configure
   make
   ```

4. **Install the Compiled Software**
   ```bash
   sudo make install
   ```

---

### Understanding Package Management

Linux distributions utilize different package formats and managers to handle software installations and updates. Here’s a brief overview:

#### Package Formats
- **DEB**: Used by Debian-based distributions like Ubuntu.
- **RPM**: Used by Red Hat-based distributions like Fedora.

#### Types of Package Managers
- **DPKG**: Low-level package manager for DEB packages.
- **APT**: High-level package manager that works with DPKG.
- **YUM**: High-level package manager for RPM packages.

---

### Verifying System Resources

You can check various system resources using these commands:

- **Disk Usage**
  ```bash
  df -h
  ```
  Displays disk space usage in a human-readable format.

- **Disk Usage (Directory summary)**
  ```bash
  du -sh
  ```
  Displays summary of a disk space usage in a human-readable format of a directory.

- **Memory Usage**
  ```bash
  free -h
  ```
  Shows memory usage, including free and used RAM.

- **System Uptime**
  ```bash
  uptime
  ```
  Displays how long the system has been running.

---

### Managing Services

You can manage system services using `systemctl`:

- **List Service Dependencies**
  ```bash
  systemctl list-dependencies
  ```

- **Check Service Status**
  ```bash
  systemctl status apache2
  ```

- **Start a Service**
  ```bash
  sudo systemctl start apache2
  ```

- **Stop a Service**
  ```bash
  sudo systemctl stop apache2
  ```

- **View Service Logs**
  ```bash
  journalctl -u apache2
  ```

---
### File System Types and Maintenance

Different file systems are used in various Linux distributions, and they require different maintenance commands:

- **File Systems**
  - **XFS**: Commonly used in Red Hat-based distributions.
  - **ext4**: Commonly used in Ubuntu.

#### Repairing File Systems
- **Repair an XFS File System**
  ```bash
  sudo xfs_repair -v /dev/vdb1
  ```

- **Repair an ext4 File System**
  ```bash
  sudo fsck.ext4 -v -f -p /dev/vdb2
  ```
---
# Change Kernel Runtime Parameters: Persistent and Non-Persistent

Kernel parameters can be modified at runtime to tune the behavior of the system. Changes can be made either temporarily (non-persistent) or permanently (persistent). Non-persistent changes are lost after a reboot, while persistent changes are retained across reboots.

## Non-Persistent Changes

To change a kernel parameter temporarily, you can use the `sysctl` command. For example, to disable IPv6, run:

```bash
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

To verify the change, you can check the current value with:

```bash
sysctl net.ipv6.conf.default.disable_ipv6
```

To view all current kernel parameters, use:

```bash
sysctl -a
```

## Persistent Changes

To make changes that persist across reboots, you need to modify configuration files located in `/etc/sysctl.d/` or `/etc/sysctl.conf`.

1. **Create a new configuration file** (e.g., `swap-less.conf`) to store your desired kernel parameters:

   ```bash
   sudo vi /etc/sysctl.conf
   ```

   Add the following line to set the `vm.swappiness` parameter:

   ```plaintext
   vm.swappiness=60
   ```

2. **Load the changes immediately**:

   ```bash
   sudo sysctl -w vm.swappiness=10
   ```

3. **To view specific parameters, you can use**:

   ```bash
   sysctl -a | grep vm.swappiness
   sudo sysctl -p # apply changes on boot
   ```

## Example: Disabling IPv6

To disable IPv6 temporarily, run:

```bash
sudo sysctl -w net.ipv6.conf.default.disable_ipv6=1
```

To make this change persistent, add the following line to a configuration file:

```plaintext
net.ipv6.conf.default.disable_ipv6=1
```

You can create or edit a configuration file as shown previously.

# SELinux File and Process Contexts

## SELinux Basics

### File and Process Contexts
Each file and process in SELinux has a context defined by a triplet:
- **User**: SELinux user mapping (not the same as the login user).
- **Role**: Predefined roles (e.g., `dev_r`, `docker_r`).
- **Type**: Type enforcement, which creates a protected software jail.
- **Level**: Multiple levels of security, typically not used in normal systems.

Example of a context:
```
unconfined_u:object_r:user_home_t:s0
```

### Context Commands
- **List file contexts**: `ls -Z`
- **List process contexts**: `ps axZ`
- **Get current SELinux status**: `getenforce` (outputs `Enforcing`, `Permissive`, or `Disabled`)

### SELinux Modes
- **Enforcing**: SELinux policy is enforced.
- **Permissive**: SELinux policy is not enforced, but violations are logged. `sudo setenforce Permissive`
- **Disabled**: SELinux is turned off.

## Enabling SELinux on Ubuntu

By default, Ubuntu uses AppArmor for security. To enable SELinux, follow these steps:

1. **Disable AppArmor**:
   ```bash
   sudo systemctl stop apparmor.service
   sudo systemctl disable apparmor.service
   ```

2. **Install SELinux**:
   ```bash
   sudo apt install selinux-basics auditd
   ```

3. **Activate SELinux**:
   ```bash
   sudo selinux-activate
   ```

4. **Update GRUB and Reboot**:
   Edit the GRUB configuration:
   ```bash
   sudo vi /etc/default/grub
   ```
   Add `selinux=1` to the `GRUB_CMDLINE_LINUX_DEFAULT` line, then reboot:
   ```bash
   sudo update-grub
   sudo reboot
   ```

5. **Relabel Filesystem**:
   After reboot, SELinux will be enabled, and the filesystem will be relabeled.

### Check SELinux Status
```bash
getenforce  # Check if in Permissive or Enforcing mode
```

## Configuring SELinux

### Create and Install a Policy Module
1. Generate a policy module:
   ```bash
   sudo audit2allow -all -M mymodule
   ```

2. Install the policy module:
   ```bash
   sudo semodule -i mymodule.pp
   ```

3. Set SELinux to enforcing mode:
   ```bash
   sudo setenforce 1
   ```

### Context Management
- **Change file context**:
  ```bash
  sudo chcon -u unconfined_u /var/log/auth.log
  sudo chcon -t user_home_t /var/log/auth.log
  ```

- **Restore default context**:
  ```bash
  sudo restorecon -R /var/www/
  ```

- **Add file context type**:
  ```bash
  sudo semanage fcontext -a -t var_log_t '/var/www/10'
  ```
- **Identify SELinux roles**
  ```
  sudo semanage user -l
  ```

## Useful Commands
- **List SELinux Users**:
  ```bash
  seinfo -u
  ```

- **List SELinux Roles**:
  ```bash
  seinfo -r
  ```

- **List SELinux Types**:
  ```bash
  seinfo -t
  ```

## Example: Managing a Web Directory
1. **Create a web directory**:
   ```bash
   sudo mkdir /var/www
   ```

2. **Set context for files in the directory**:
   ```bash
   sudo restorecon -R /var/www/
   ```

3. **Check context**:
   ```bash
   ls -Z /var/www/
   ```
---
# Docker
## Basic Docker Commands
- View Docker options: 
  ```bash
  docker --help
  ```
- Search for an image: 
  ```bash
  docker search nginx
  ```
- Pull a Docker image: 
  ```bash
  docker pull nginx
  docker pull ubuntu/nginx
  ```
- Pull a specific image tag (version): 
  ```bash
  docker pull nginx:1.22.1
  ```
- List Docker images: 
  ```bash
  docker images
  ```
- Remove a Docker image: 
  ```bash
  docker rmi ubuntu/nginx
  docker rmi nginx:1.22.1  # Delete a specific version
  ```

## Creating and Running Containers
- Run a container: 
  ```bash
  docker run nginx
  ```
- Run a container with detached mode, publish port, and custom name: 
  ```bash
  docker run --detach --publish 8080:80 --name mywebserver nginx
  ```
  This makes the container accessible to the outside world via port 8080.
  
- List running containers: 
  ```bash
  docker ps
  ```
- List all containers (including stopped ones): 
  ```bash
  docker ps -a
  ```
- Start and stop containers:
  ```bash
  docker start container_id
  docker stop container_name
  ```

### Netcat Example
To verify network connectivity:
```bash
GET /
nc localhost 8080
ctrl + D  # exit netcat session
```

- Difference between `docker run` and `docker start`:  
  `docker run` builds and starts a container, while `docker start` only starts an existing container.

- Remove a container: 
  ```bash
  docker rm container_name
  ```

- Removing an image after stopping and removing the container: 
  ```bash
  docker stop mywebserver
  docker rm mywebserver
  docker rmi nginx
  ```

- Auto-restart a container on failure:
  ```bash
  docker run --detach --publish 8080:80 --name mywebserver nginx --restart always
  ```

## Dockerfile Example
Create a custom Docker image:
```Dockerfile
FROM nginx
COPY index.html /usr/share/nginx/html/index.html
```
Build the image:
```bash
docker build --tag mycustomnginx:1.0 myimage
```

---

# Manage and Configure Virtual Machines

## Basic Virtual Machine Management with `virsh`

- Install required software:
  ```bash
  sudo apt install virt-manager
  ```

- Define a virtual machine using XML:
  ```bash
  virsh define testmachine.xml
  ```
  Example XML configuration (`testmachine.xml`):
  ```xml
  <domain type="qemu">
      <name>TestMachine</name>
      <memory unit="GiB">1</memory>
      <vcpu>1</vcpu>
      <os>    
          <type arch="x86_64">hvm</type>
      </os>
  </domain>
  ```

- Manage VMs:
  ```bash
  virsh help
  virsh list         # List running VMs
  virsh list --all   # List all VMs
  virsh start TestMachine
  virsh shutdown TestMachine
  virsh destroy TestMachine  # Force shutdown
  virsh undefine TestMachine --remove-all-storage
  virsh autostart VM2 # autostart at boot
  ```

- Configure VM settings:
  ```bash
  virsh setvcpus TestMachine 2 --config
  virsh setmaxmem VM2 80M --config # set max memory
  virsh setmem VM2 80M --config # set ram memory
  ```

## Creating and Booting Virtual Machines

- Download a minimal cloud image (ISO) and verify its checksum:
  ```bash
  sha256sum -c SHA256SUMS 2>&1 | grep OK
  ```

- Resize a virtual disk image:
  ```bash
  qemu-img resize ubuntu-24.img 10G
  ```

- Copy disk image to storage pool:
  ```bash
  sudo cp ubuntu.img /var/lib/libvirt/images/
  ```

- Install and start a VM:
  ```bash
  virt-install --osinfo ubuntu24    --name ubuntu1   --memory 1024 --vcpus 1 --import --disk /var/lib/libvirt/images/ubuntu.img                               --graphics none
  virt-install --osinfo ubuntu22.04 --name kk-ubuntu --memory 1024 --vcpu  1 --import --disk /var/lib/libvirt/images/ubuntu-22.04-minimal-cloudimg-amd64.img  --graphics none --network network=default
  ```

### Auto-generate root password on cloud-init:
```bash
virt-install --osinfo ubuntu24 --name ubuntu1 --memory 1024 --vcpus 1 --import --disk /var/lib/libvirt/images/ubuntu.img --graphics none --cloud-init root-password-generate=on
```

Copy the root password from the output.

### Installing an OS from ISO:
```bash
virt-install --osinfo debian12 --name debian1 --memory 1024 --vcpus 1 --disk size=10 \
--location /var/lib/libvirt/boot/debian12-netinst.iso --graphics none --extra-args "console=ttyS0"
```
---

# User and Group Management in Linux

Managing users and groups is an essential part of Linux system administration. This guide covers the differences between `adduser` and `useradd`, along with various commands for creating, modifying, and deleting users and groups.

---

## 1. **Add User Accounts**

### Using `adduser` (High-level command):
`adduser` is a more user-friendly command with interactive prompts.

- **Create a new user with default settings**:
  ```bash
  sudo adduser john
  ```
  - Creates `/home/john`
  - Assigns `/bin/bash` as the default shell
  - Prompts for a password and additional information (optional)

- **Create a user with a custom shell and home directory**:
  ```bash
  sudo adduser --shell /bin/zsh --home /home/otherdirectory john
  ```

- **Delete a user**:
  ```bash
  sudo deluser john
  ```

- **Delete a user and their home directory**:
  ```bash
  sudo deluser --remove-home john
  ```

### Using `useradd` (Low-level command):
`useradd` provides more control but does not create a home directory or set a password by default.

- **Create a new user (default settings, no home directory)**:
  ```bash
  sudo useradd john
  ```

- **Create a user and automatically set up the home directory**:
  ```bash
  sudo useradd -m john
  ```

- **Set a custom shell and home directory**:
  ```bash
  sudo useradd -s /bin/zsh -d /home/otherdirectory john
  ```

- **Specify a custom UID for a user**:
  ```bash
  sudo useradd -u 1100 john
  ```

- **Delete a user**:
  ```bash
  sudo userdel john
  ```

- **Delete a user and their home directory**:
  ```bash
  sudo userdel -r john
  ```

---

## 2. **Modify User Accounts**

### Using `usermod`:
`usermod` modifies user settings such as login names, home directories, shells, and more.

- **Change a user's home directory and move existing files**:
  ```bash
  sudo usermod -d /home/newdir -m john
  ```

- **Change a user's login name**:
  ```bash
  sudo usermod --login jane john
  ```

- **Change a user's shell**:
  ```bash
  sudo usermod --shell /bin/othershell john
  ```

- **Lock a user account (disable login)**:
  ```bash
  sudo usermod --lock john
  ```

- **Unlock a user account**:
  ```bash
  sudo usermod --unlock john
  ```

- **Expire a user account (set an expiry date)**:
  ```bash
  sudo usermod -e 2030-03-01 john
  ```

- **Add user to sudo group**
  ```bash
  sudo usermod -aG sudo mary
  ```
---

## 3. **Password Management**

### Using `passwd`:
The `passwd` command is used to set and change passwords for users.

- **Set or change a user’s password**:
  ```bash
  sudo passwd john
  ```

- **Force a user to change their password on the next login**:
  ```bash
  sudo chage --lastday 0 john
  ```

- **Set password expiration (e.g., 30 days)**:
  ```bash
  sudo chage --maxdays 30 john
  ```

- **Disable password expiration**:
  ```bash
  sudo chage --maxdays -1 john
  ```

---

## 4. **Group Management**

### Using `addgroup` and `groupadd`:
Linux has similar commands for creating groups, like `adduser`/`useradd`.

- **Create a group with `addgroup`** (user-friendly):
  ```bash
  sudo addgroup developers
  ```

- **Create a group with `groupadd`** (low-level):
  ```bash
  sudo groupadd developers
  ```

### Managing Group Memberships:

- **Add a user to a group**:
  ```bash
  sudo gpasswd --add john developers
  ```

- **Remove a user from a group**:
  ```bash
  sudo gpasswd --delete john developers
  ```

- **Change a user’s primary group**:
  ```bash
  sudo usermod -g developers john
  ```

### Modify or Delete Groups:

- **Rename a group**:
  ```bash
  sudo groupmod --new-name programmers developers
  ```

- **Delete a group**:
  ```bash
  sudo groupdel developers
  ```

---

## 5. **System and Service Accounts**

- **Create a system account (for daemons/services)**:
  ```bash
  sudo adduser --system --no-create-home sysacc
  ```

- **Delete a system account**:
  ```bash
  sudo deluser --remove-home sysacc
  ```

---

## 6. **View User and Group Information**

- **View the `/etc/passwd` file** (list of all users):
  ```bash
  cat /etc/passwd
  ```

- **View the `/etc/group` file** (list of all groups):
  ```bash
  cat /etc/group
  ```

- **Check a specific user's information**:
  ```bash
  id john
  ```

- **Check a user’s group memberships**:
  ```bash
  groups john
  ```

- **View user details in `/etc/passwd`**:
  ```bash
  grep -i john /etc/passwd
  ```

---

## Summary

- **`adduser`**: High-level, interactive, user-friendly, sets up home directory, shell, etc.
- **`useradd`**: Low-level, requires manual configuration, more control.
- **User modification**: `usermod` is used for altering user details like login names, home directories, shells, and locking/unlocking accounts.
- **Password management**: `passwd` and `chage` control password settings and expiration policies.
- **Group management**: `addgroup`, `groupadd`, `gpasswd`, and `groupmod` manage group memberships and details.
---

# Manage System-Wide Environment Profiles

This guide will help you manage system-wide environment profiles in Linux, including modifying environment variables, setting up login scripts, and customizing the template environment for new users.

## Environment Variables

You can view the current environment variables using the following commands:

- **View environment variables**:
  ```bash
  printenv
  ```
  or
  ```bash
  env
  ```

### Modify Environment Variables

You can adjust environment variables like `HISTSIZE`, which determines the number of commands stored in the shell's history.

- **Change `HISTSIZE`**:
  ```bash
  HISTSIZE=222  # Sets the size of the history to 222 commands
  ```

- **View command history**:
  ```bash
  history
  ```

### Persistent Environment Changes

To make environment variable changes persistent, add them to the relevant configuration files such as `.bashrc` or `/etc/environment`.

- **Modify `/etc/environment`**:
  This file sets system-wide environment variables.
  ```bash
  sudo vi /etc/environment
  ```

After making changes, logout or restart the system for them to take effect.

- **Logout to apply changes**:
  ```bash
  logout
  ```

---

## Manage System-Wide Login Commands

You can run specific commands automatically upon user login by placing scripts in the `/etc/profile.d/` directory.

- **Create a login script**:
  Add a script that runs after a user logs in, such as showing the last login information.
  ```bash
  sudo vi /etc/profile.d/lastlogin.sh
  ```

- **Example content**:
  ```bash
  #!/bin/bash
  echo "Welcome! Last login information:"
  lastlog
  ```

This script will execute automatically when users log in, displaying the last login information.

---

## Manage Template User Environment

The `/etc/skel/` directory contains template files that are copied into the home directory of newly created users. You can customize this directory to set up default configuration files for new users.

- **Create a custom README file**:
  Place a file in `/etc/skel/` to inform new users about system policies.
  ```bash
  sudo vi /etc/skel/README
  ```

- **Example `README` content**:
  ```text
  Please don't run CPU-intensive processes between 8AM and 10PM.
  ```

When a new user is created, this file will automatically be placed in their home directory.

### Create a New User and Verify

- **Create a new user**:
  ```bash
  sudo adduser trinity
  ```

- **Verify the new user's home directory**:
  Check that the custom `README` and other template files are copied to the new user's home directory.
  ```bash
  sudo ls -a /home/trinity
  ```

---

## Customize `.bashrc` for New Users

The `.bashrc` file is a configuration script that runs whenever a new shell session is started. To provide all new users with a default `.bashrc` file, you can place a customized version in the `/etc/skel/` directory.

- **Modify the template `.bashrc` file**:
  ```bash
  sudo vi /etc/skel/.bashrc
  ```

This will ensure that every new user gets a predefined `.bashrc` file in their home directory upon account creation.
---

# User Resource Limits and Privileges Management
## Configure User Resource Limits

User resource limits control the amount of system resources (CPU, processes, file sizes, etc.) that a user or group can consume. These limits can be configured in `/etc/security/limits.conf`.

### Edit Limits Configuration File

To configure resource limits, you need to modify the `/etc/security/limits.conf` file.

- **Format**:
  ```
  <domain> <type> <item> <value>
  ```

- **Example Entries**:
  ```bash
  sudo vi /etc/security/limits.conf
  ```

  ```bash
  trinity hard nproc 10       # Trinity can run a maximum of 10 processes (hard limit)
  @developers soft nproc 10   # All users in the 'developers' group have a soft limit of 10 processes
  jane  soft  fsize  1024     # For the user called jane make sure she can create files not larger than 1024 kilobytes. Make this a soft limit.
  * soft cpu 5                # All users have a CPU time limit of 5 except where overridden
  ```

  Additional examples for user `trinity`:
  ```bash
  trinity hard nproc 30       # Hard limit of 30 processes
  trinity soft nproc 10       # Soft limit of 10 processes
  ```

- **Alternative Format**:
  The format without a type can also be used:
  ```bash
  trinity - nproc 20          # Hard limit on the number of processes for trinity
  ```

### Items in Limits Configuration

- **`nproc`**: Maximum number of processes a user can run.
- **`fsize`**: Maximum size of files a user can create.
- **`cpu`**: Maximum CPU time (in minutes) that a user can use.

#### Example:
```bash
trinity hard nproc 20  # Hard limit of 20 processes
trinity soft nproc 10  # Soft limit of 10 processes
* soft cpu 1           # Every user has 1 minute of CPU time
```

### Testing the Configuration

To test the limits for a specific user, log in as the user and check the limits:

```bash
sudo -iu trinity
```

- Check running processes:
  ```bash
  ps | less
  ```

- Attempt to exceed the process limit:
  ```bash
  # Try running more processes than allowed, it should fail after the limit is reached
  ```

### Check Current Session Limits

To view the current resource limits for your session, use the `ulimit` command:

- **View all current session limits**:
  ```bash
  ulimit -a
  ```

- **Set the maximum number of user processes**:
  ```bash
  ulimit -u 5000
  ```

---

# Manage User Privileges

User privileges are controlled by group membership and the `sudo` system. Users can be assigned specific permissions by being added to privileged groups like `sudo`.

### View User Groups

You can check the groups a user belongs to with the following command:

```bash
groups
```

Example:
```bash
aaron family sudo  # User 'aaron' is part of the 'family' and 'sudo' groups
```

### Add a User to the `sudo` Group

To grant a user administrative privileges, add them to the `sudo` group:

```bash
sudo gpasswd -a trinity sudo
```

### Remove a User from the `sudo` Group

To revoke a user's administrative privileges, remove them from the `sudo` group:

```bash
sudo gpasswd -d trinity sudo
```

### Manage sudo Privileges with `visudo`

The `visudo` command is used to safely edit the `/etc/sudoers` file, which controls who can use `sudo` and how.

- **Open sudoers file**:
  ```bash
  sudo visudo
  ```

- **Example Entries**:
  ```bash
  %sudo   ALL=(ALL:ALL) ALL     # All users in the 'sudo' group can run any command as any user or group
  trinity ALL=(ALL) ALL         # The user 'trinity' can run any command as any user or group
  %developers ALL=(ALL)         # All users in the 'developers' group can run any command as any user or group
  ```

- **Allow specific users to execute commands**:
  ```bash
  trinity ALL=(aaron,john) ALL  # Trinity can run commands as 'aaron' or 'john'
  ```

- **Allow specific commands without a password**:
  ```bash
  trinity ALL=(ALL) NOPASSWD: ALL  # Trinity can run all commands without being prompted for a password
  ```

### Test sudo Privileges

You can test a user's `sudo` privileges by running a command as the user with `sudo`:

```bash
sudo -u trinity ls /home/trinity
```
---
To manage root privileges in Linux, there are two main ways to switch to the root user: using `sudo` or `su`. Both have different use cases, access methods, and alternatives. Let's break down the creative ways to handle root login efficiently.

# Root Account Management (sudo)

`sudo` is the most common way to perform root actions on a system without logging in directly as the root user. It temporarily grants superuser privileges to the current user.

### Key Commands:

- **`sudo -i`**: Opens a root shell as if the user logged in as root. It reads root's environment and applies its configurations.
  ```bash
  sudo -i
  # You are now logged in as root with root's environment variables.
  ```

- **`sudo -s`**: Opens a root shell but keeps the current user's environment variables.
  ```bash
  sudo -s
  # You have root privileges, but you retain your current user's shell environment.
  ```

- **`sudo --login` or `sudo -l`**: Similar to `sudo -i`, this initiates a login shell for root. It sets root's home directory, PATH, and other environment variables.
  ```bash
  sudo --login
  # Full login shell as root.
  ```

### When to Use:
- **Routine root tasks**: If you just need temporary root access, `sudo -i` is preferred.
- **Preserving user environment**: When you want to keep your own environment but gain root privileges, use `sudo -s`.

---

## 2. **Using `su` for Root Login (`su -` and Alternatives)**

`su` switches directly to the root account. Unlike `sudo`, `su` requires the root password instead of the current user's password.

### Key Commands:

- **`su -`**: Switches to root and logs in with root's environment, changing to root's home directory (`/root`).
  ```bash
  su -
  # You are now logged in as root with root's full environment and working directory.
  ```

- **`su`** (without `-`): Switches to root without applying root’s environment. You stay in the current user's directory.
  ```bash
  su
  # You are root, but the environment is inherited from the previous user.
  ```

- **`su -l` or `su --login`**: These are equivalent to `su -`, providing a full root login shell.
  ```bash
  su -l
  # Similar to su -, logs you into root's environment and home directory.
  ```

### When to Use:
- **Full root session**: Use `su -` for a complete root environment. It’s best for performing administrative tasks that require root’s setup, like installing software.
- **Root access without full login**: If you want root access but keep your environment (and stay in your current directory), `su` without `-` is a better choice.

---

## 3. **Key Differences: `sudo` vs `su`**

| Feature                  | `sudo -i` / `sudo -s`     | `su -` / `su`           |
|------------------------- |-------------------------- |-------------------------|
| **Password required**    | Current user's password   | Root password           |
| **Session scope**        | Single command or session | Full root shell         |
| **Environment**          | `sudo -i`: root's env<br>`sudo -s`: user's env | `su -`: root's env<br>`su`: user's env |
| **Security**             | More secure (no need for root password) | Less secure (root password required) |
| **Best for**             | Quick tasks with elevated privileges | Full root session with root’s environment |

## Final thougths

The choice between `sudo` and `su` depends on the situation. `sudo` is better for quick and secure privilege escalation, especially when multiple administrators need access without revealing the root password. On the other hand, `su` is preferred for full-root sessions where the environment and password are controlled centrally. Both provide flexibility, but combining them creatively helps manage privileges more efficiently.

---

# Configure the System to Use LDAP User and Group Accounts

Lightweight Directory Access Protocol (LDAP) allows centralized management of users and groups across multiple systems.

## Step 1: Verify Existing Users
To view the existing users in the system, use:
```bash
cat /etc/passwd
```
For example:
```
jeremy:x:1000:1000:Jeremy Morgan:/home/jeremy:/bin/bash
```

If you attempt to check non-existing users:
```bash
id john  # No such user
id jane  # No such user
```

## Step 2: Set Up the LDAP Server
- **Start an LDAP server** using LXD (Lightweight container daemon):
    ```bash
    lxd init  # Initializes LXD with at least 5GB of space
    lxc import ldap-server.tar.xz  # Import the LDAP server image
    lxc list  # List LXC containers
    lxc start ldap-server  # Start the LDAP server
    ```

## Step 3: Install LDAP Client Packages
On the client system, install the necessary LDAP packages:
```bash
sudo apt update
sudo apt install libnss-ldapd  # Installs the extended version of LDAP client
```

During installation, configure the LDAP domain, for example:
```bash
dc=kodekloud,dc=com
```

## Step 4: Modify System Configurations for LDAP
Ensure that `/etc/nsswitch.conf` contains LDAP configuration:
```bash
# Ensure LDAP is used for system files
passwd: files systemd ldap
```

Check the LDAP client configuration file:
```bash
sudo cat /etc/nslcd.conf  # LDAP configuration file
```

## Step 5: Verify LDAP User Accounts
After configuring the system, you can check LDAP user accounts:
```bash
id john  # Should now exist and belong to ldapusers group
id jane  # Should now exist and belong to ldapusers group
```

## Step 6: Retrieve LDAP User Information
- To list all users (including LDAP users):
    ```bash
    getent passwd
    ```

- To list only LDAP users:
    ```bash
    getent passwd --service ldap
    ```

- To list all groups (including LDAP groups):
    ```bash
    getent group --service ldap
    ```

## Step 7: Create Home Directories for LDAP Users
LDAP users don’t automatically get home directories. You need to configure the system to create home directories on login.

Enable this feature using:
```bash
sudo pam-auth-update  # Enable "Create home directory on login"
```

Now, when an LDAP user logs in:
```bash
sudo login jane
```
A home directory is created for them at `/home/jane`.

## Step 8: Manage LDAP User Accounts Centrally
By using LDAP, managing user accounts across multiple Linux servers becomes easier. You can CRUD (create, read, update, delete) users from a single central location, and the changes will reflect across all configured servers.

---
# Networking Configuration and Hostname Resolution
## IPv4 and IPv6 Networking
### IPv4 BasicS
- **IPv4** addresses are 32-bit numbers split into four 8-bit octets.
- Each octet can range from `0 to 255`.
- Example: `192.168.1.101 -> 11000000.10101000.00000001.01100101`
- CIDR (Classless Inter-Domain Routing) notation is used to define network prefixes.
  - Example: `192.168.1.101/24`
    - `/24` means the first 24 bits (192.168.1) represent the network.
    - Devices are identified by the remaining bits, e.g., `.101`.

### IPv6 Basics
- **IPv6** addresses are 128-bit numbers, represented as 8 groups of hexadecimal digits.
- Example: `2001:0db8:0000:0000:0000:ff00:0042:8329`
  - Abbreviated as: `2001:db8::ff00:42:8329`.
- CIDR notation is also supported in IPv6.
  - Example: `2001:db8::ff00:42:8329/64`.

---
# Configuring Networking Interfaces
## 1. Ubuntu Family

### Using `ip` Command (Temporary Settings)
- View all interfaces: 
  ```bash
  ip link
  ip address
  ip -c address     # With colors
  ip addr show eth0 # show specific interface
  ```
- Assign an IP address:
  ```bash
  sudo ip addr add 10.0.0.40/24 dev enp0s8
  ```
- Activate or deactivate an interface:
  ```bash
  sudo ip link set dev enp0s8 up
  sudo ip link set dev enp0s8 down
  ```
- **Note**: These changes are temporary and will be reset after reboot.

### Using `netplan` (Persistent Settings)
- Edit `/etc/netplan/99-mysettings.yaml` to make permanent network configurations.
  ```yaml
  network:
    ethernets:
      enp0s3:
        dhcp4: false
        addresses:
          - 10.0.0.9/24
          - fe80::921b:eff:fe3d:abcd/64
    version: 2
  ```
- Apply the configuration:
  ```bash
  sudo netplan try
  sudo netplan apply
  ```
- Configure routes and DNS in `netplan`:
  ```yaml
  network:
    ethernets:
      enp0s3:
        dhcp4: false
        addresses:
          - 10.0.0.9/24
          - fe80::921b:eff:fe3d:abcd/64
        nameservers:
          addresses:
            - 8.8.8.8
            - 8.8.4.4
        routes:
          - to: default
            via: 10.0.0.1  # Gateway
  ```

## 2. CentOS & Fedora (RedHat Family)

### Using `nmcli` (NetworkManager Command Line Interface)
- View device status:
  ```bash
  nmcli device status
  ```
- Show active connections:
  ```bash
  nmcli connection show
  ```
- Edit a connection:
  ```bash
  nmcli connection edit ens33
  ```
- Set static IP address:
  ```bash
  sudo nmcli connection modify ens33 ipv4.method manual ipv4.addresses "192.168.80.12/24" ipv4.gateway "192.168.80.2" ipv4.dns "8.8.8.8 8.8.4.4" autoconnect yes 
  ```
  **Breakdown**
  ```bash
  nmcli connection modify ens33 ipv4.addresses 10.0.0.9/24
  nmcli connection modify ens33 ipv4.gateway 10.0.0.1
  nmcli connection modify ens33 ipv4.dns "8.8.8.8,8.8.4.4"
  nmcli connection modify ens33 ipv4.method manual
  ```
- Bring the connection down and back up:
  ```bash
  nmcli connection down ens33
  nmcli connection up ens33
  ```

## Additional Notes
- Ensure that the IP addresses assigned do not conflict with existing devices on the network.
- Use `ip route` to verify routing configurations.
- For persistent changes, remember to apply configurations appropriately.
---

# DNS Server Configuration
## `/etc/hosts` File
You can use the `/etc/hosts` file to add local DNS entries for quick name resolution:
```bash
192.168.0.1 db-server
192.168.0.2 web-server
```

## `/etc/resolv.conf` File
To configure DNS servers globally, edit the `/etc/resolv.conf` file:
```bash
nameserver 192.168.1.100
nameserver 8.8.8.8  # Google's public DNS
search mycompany.com prod.mycompany.com
```

## `/etc/systemd/resolved.conf` File
On systems using systemd-resolved, this file may be automatically generated, and manual changes may not persist.
To configure DNS settings when using `systemd-resolved`, edit the `/etc/systemd/resolved.conf` file:
```bash
[Resolve]
DNS=8.8.8.8 8.8.4.4  # Google's public DNS
FallbackDNS=1.1.1.1   # Cloudflare DNS
Domains=example.com    # Optional: define search domains
```
After editing, restart the `systemd-resolved` service:
```bash
sudo systemctl restart systemd-resolved
```

## Differences Between `/etc/resolv.conf` and `/etc/systemd/resolved.conf`

### `/etc/resolv.conf`
- **Purpose**: Traditional DNS resolution configuration.
- **Format**:
  ```bash
  nameserver <IP_ADDRESS>
  search <DOMAIN>
  ```

### `/etc/systemd/resolved.conf`
- **Purpose**: Configuration for the `systemd-resolved` service.
- **Format**:
  ```bash
  [Resolve]
  DNS=<DNS_SERVER_1> <DNS_SERVER_2>
  FallbackDNS=<FALLBACK_DNS>
  Domains=<SEARCH_DOMAIN>
  ```

### Example Comparison

**1. `/etc/resolv.conf` Example**
```bash
nameserver 192.168.1.100
nameserver 8.8.8.8
search mycompany.com
```

**2. `/etc/systemd/resolved.conf` Example**
```bash
[Resolve]
DNS=8.8.8.8 8.8.4.4
FallbackDNS=1.1.1.1
Domains=mycompany.com
```

### `nsswitch.conf` File
You can modify the DNS lookup order in the `/etc/nsswitch.conf` file:
```bash
hosts: files dns
```

### DNS Record Types
- **A Record**: Maps a domain to an IPv4 address.
- **AAAA Record**: Maps a domain to an IPv6 address.
- **CNAME**: Maps one domain to another domain.

## Network Testing Tools

### DNS Resolution
- `nslookup`: Basic DNS query tool.
- `dig`: Advanced DNS query tool.

### Network Services and Ports
- View active services and ports:
  ```bash
  sudo ss -ltunp  # Lists TCP and UDP connections with processes
  sudo ss -tunlp  # can be written as well
  ```
- Check open ports:
  ```bash
  netstat -an | grep 80 | grep -i LISTEN
  sudo netstat -natulp | grep postgres | grep LISTEN
  ```

## Troubleshooting Network Issues

- **Check network connectivity**:
  ```bash
  traceroute domain.com
  ```
- **Check DNS resolution**:
  ```bash
  nslookup domain.com
  ```
- **Check interface status**:
  ```bash
  ip link
  ```
- **Check network routes**:
  ```bash
  ip route
  ```
---

# Network Bonding vs Bridging

## 1. **Network Bonding**

### Definition
Network bonding is the process of combining two or more network interfaces into a single, logical interface. This allows for redundancy (failover) and increased throughput by spreading network traffic across multiple physical devices.

### Benefits
- **Redundancy**: If one interface fails, the other takes over without service interruption.
- **Increased Bandwidth**: Combines the bandwidth of multiple network connections.
- **Load Balancing**: Distributes traffic evenly across all interfaces in the bond.

### Use Case
- High-availability networks where network failure protection is critical.
- Environments needing increased data throughput (e.g., data centers).

---

## 2. **Network Bridging**

### Definition
Network bridging is the process of connecting multiple networks or network segments at the data link layer (Layer 2) so that they act as a single network. A bridge allows communication between separate network segments by forwarding traffic from one to another.

### Benefits
- **Interconnectivity**: Connects different segments of a network.
- **Traffic Management**: Reduces collision domains by isolating network segments.
- **Transparency**: Devices on different segments communicate as if they are on the same network.

### Use Case
- Virtualization environments where virtual machines (VMs) need to communicate over different physical networks.
- Home or office environments where multiple LAN segments need to be interconnected.

---

## 3. **Comparison: Bonding vs Bridging**

| **Aspect**           | **Bonding**                                                 | **Bridging**                                                 |
|----------------------|-------------------------------------------------------------|--------------------------------------------------------------|
| **Primary Function**  | Combines multiple interfaces into one logical interface     | Connects multiple network segments into one network           |
| **Failover**          | Provides redundancy by switching to another interface       | No redundancy—used for interconnecting networks               |
| **Performance**       | Increases throughput by aggregating interfaces              | Does not increase throughput—manages traffic between segments |
| **Typical Use Case**  | High-availability, increased bandwidth needs                | Virtual machine networking, connecting LAN segments           |

---

## Summary:
- **Bonding** is ideal for improving reliability and performance by combining multiple network interfaces into one. It’s often used in high-performance and high-availability scenarios like data centers or critical infrastructure.
  
- **Bridging** is used to interconnect different network segments or virtual networks, allowing them to communicate as if they were part of the same network. It's commonly used in virtualization or scenarios requiring segmented but interconnected networks.

Here’s a textual representation of the figure that compares **Network Bonding** and **Network Bridging**:

```
               +-------------------------------------------+      +-------------------------------------------+
               |                                           |      |                                           |
               |               NETWORK BONDING             |      |              NETWORK BRIDGING             |
               |                                           |      |                                           |
               +-------------------------------------------+      +-------------------------------------------+
                            |                                                 |
                            |                                                 |
        +-----------------------------------+                      +-----------------------------------+
        |   Interface 1 (eth0)              |                      |   Segment A                      |
        +-----------------------------------+                      +-----------------------------------+
                            |                                                 |
                            |                                                 |
        +-----------------------------------+                      +-----------------------------------+
        |   Interface 2 (eth1)              |                      |   Segment B                      |
        +-----------------------------------+                      +-----------------------------------+
                            |                                                 |
                            |                                                 |
                            |                                                 |
                   +-----------------+                                +-----------------+
                   |   Bonded Link    |                                |   Bridge Device |
                   +-----------------+                                +-----------------+
                            |                                                 |
                            |                                                 |
                   +-----------------+                                +-----------------+
                   |      Switch      |                                |      Switch      |
                   +-----------------+                                +-----------------+
                            |                                                 |
                            |                                                 |
                +--------------------+                              +--------------------+
                | Network or Internet|                              | Network or Internet|
                +--------------------+                              +--------------------+

```

### Explanation of the Figure:

1. **Network Bonding**:
   - Two or more network interfaces (e.g., eth0 and eth1) are bonded into a **single logical interface**. This bonded link increases throughput and provides redundancy.
   - The bonded link connects to a switch and then to the wider network or internet.

2. **Network Bridging**:
   - Multiple network segments (e.g., Segment A and Segment B) are connected via a **bridge device**.
   - The bridge manages traffic between the segments and connects them as if they were a single network.
   - The bridge connects to a switch and then to the wider network or internet.

In this textual diagram, each concept is represented in a straightforward, linear way. It showcases the relationships between interfaces, segments, and the overall network architecture for **bonding** and **bridging**.

# Network Configuration with Netplan and Firewall Setup
## Netplan Overview

Netplan is a network configuration tool for Linux that uses YAML files to define the network settings. The configuration files are typically located in `/etc/netplan/`.

## Setting Up a Bridge

### Step 1: Initial Configuration

You can create a bridge by copying an example configuration file:

```bash
sudo cp /usr/share/doc/netplan/examples/bridge.yaml /etc/netplan/99-bridge.yaml
sudo chmod 600 /etc/netplan/99-bridge.yaml
```

Here’s a sample configuration for the bridge:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp3s0:
            dhcp4: no
    bridges:
        br0:
            dhcp4: yes
            interfaces:
                - enp3s0
```

### Step 2: Modifying the YAML File

Next, modify the file to include more interfaces:

```bash
vi /etc/netplan/99-bridge.yaml
```

Updated configuration:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s8: # won't get an IP
            dhcp4: no
        enp0s9: # won't get an IP
            dhcp4: no
    bridges:
        br0: 
            dhcp4: yes
            interfaces:
                - enp0s8
                - enp0s9
```

### Step 3: Applying the Configuration

Run the following commands to test and apply the configuration:

```bash
netplan try  # test the configuration
netplan apply  # apply the configuration
```

Check the link status:

```bash
ip -c link
```

## Setting Up a Bond

### Step 1: Removing the Bridge

If you need to set up a bond instead, first remove the bridge:

```bash
sudo ip link delete br0
```

### Step 2: Bond Configuration

Copy the bond configuration example:

```bash
sudo cp /usr/share/doc/netplan/examples/bonding.yaml /etc/netplan/99-bond.yaml
sudo chmod 600 /etc/netplan/99-bond.yaml
```

Edit the bond configuration:

```bash
vi /etc/netplan/99-bond.yaml
```

Example bond configuration:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s8:
            dhcp4: no
        enp0s9:
            dhcp4: no
    bonds:
        bond0:
            dhcp: yes
            interfaces:
                - enp0s8
                - enp0s9
            parameters:
                mode: active-backup
                primary: enp0s8
                mtu-monitor-interval: 100
```

### Bonding Modes

There are seven bonding modes available, each suited for different scenarios:

- **Mode 0: "round-robin"** - Transmits packets in a sequential order from the first available interface to the last.
- **Mode 1: "active-backup"** - Only one interface is active at a time; if it fails, another takes over.
- **Mode 2: "XOR"** - Selects the interface based on the XOR operation of the source and destination MAC addresses.
- **Mode 3: "broadcast"** - Transmits packets on all slave interfaces.
- **Mode 4: "IEEE 802.3ad"** - Creates a bond that supports link aggregation, increasing bandwidth.
- **Mode 5: "adaptive transmit load balancing"** - Distributes outbound traffic based on the current load on each interface.
- **Mode 6: "adaptive load balancing"** - Combines adaptive transmit load balancing and receive load balancing.

### Step 3: Applying the Bond Configuration

Test and apply the bond configuration:

```bash
netplan try  # test the configuration
netplan apply  # apply the configuration
```
# Network Configuration with Netplan and Firewall Setup

This README covers the configuration of network interfaces using Netplan, including setting up a bridge and a bond, as well as configuring firewall rules with UFW (Uncomplicated Firewall) and IPTables.

## Netplan Overview

Netplan is a network configuration tool for Linux that uses YAML files to define the network settings. The configuration files are typically located in `/etc/netplan/`.

## Setting Up a Bridge

### Step 1: Initial Configuration

You can create a bridge by copying an example configuration file:

```bash
sudo cp /usr/share/doc/netplan/examples/bridge.yaml /etc/netplan/99-bridge.yaml
sudo chmod 600 /etc/netplan/99-bridge.yaml
```

Here’s a sample configuration for the bridge:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp3s0:
            dhcp4: no
    bridges:
        br0:
            dhcp4: yes
            interfaces:
                - enp3s0
```

### Step 2: Modifying the YAML File

Next, modify the file to include more interfaces:

```bash
vi /etc/netplan/99-bridge.yaml
```

Updated configuration:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s8: # won't get an IP
            dhcp4: no
        enp0s9: # won't get an IP
            dhcp4: no
    bridges:
        br0: 
            dhcp4: yes
            interfaces:
                - enp0s8
                - enp0s9
```

### Step 3: Applying the Configuration

Run the following commands to test and apply the configuration:

```bash
netplan try  # test the configuration
netplan apply  # apply the configuration
```

Check the link status:

```bash
ip -c link
```

## Setting Up a Bond

### Step 1: Removing the Bridge

If you need to set up a bond instead, first remove the bridge:

```bash
sudo ip link delete br0
```

### Step 2: Bond Configuration

Copy the bond configuration example:

```bash
sudo cp /usr/share/doc/netplan/examples/bonding.yaml /etc/netplan/99-bond.yaml
sudo chmod 600 /etc/netplan/99-bond.yaml
```

Edit the bond configuration:

```bash
vi /etc/netplan/99-bond.yaml
```

Example bond configuration:

```yaml
network:
    version: 2
    renderer: networkd
    ethernets:
        enp0s8:
            dhcp4: no
        enp0s9:
            dhcp4: no
    bonds:
        bond0:
            dhcp: yes
            interfaces:
                - enp0s8
                - enp0s9
            parameters:
                mode: active-backup
                primary: enp0s8
                mtu-monitor-interval: 100
```

### Bonding Modes

There are seven bonding modes available, each suited for different scenarios:

- **Mode 0: "round-robin"** - Transmits packets in a sequential order from the first available interface to the last.
- **Mode 1: "active-backup"** - Only one interface is active at a time; if it fails, another takes over.
- **Mode 2: "XOR"** - Selects the interface based on the XOR operation of the source and destination MAC addresses.
- **Mode 3: "broadcast"** - Transmits packets on all slave interfaces.
- **Mode 4: "IEEE 802.3ad"** - Creates a bond that supports link aggregation, increasing bandwidth.
- **Mode 5: "adaptive transmit load balancing"** - Distributes outbound traffic based on the current load on each interface.
- **Mode 6: "adaptive load balancing"** - Combines adaptive transmit load balancing and receive load balancing.

### Step 3: Applying the Bond Configuration

Test and apply the bond configuration:

```bash
netplan try  # test the configuration
netplan apply  # apply the configuration
```
---
## Configuring Packet Filtering with UFW
### Step 1: Basic UFW Commands

Check the status of UFW:

```bash
sudo ufw status
```

Allow SSH traffic:

```bash
sudo ufw allow 22  # allow SSH for both TCP and UDP
sudo ufw allow 22/tcp  # allow only TCP
sudo ufw enable  # enable UFW
sudo ufw status verbose  # check status in detail
```

### Step 2: Allowing and Denying Traffic

Add specific rules for incoming and outgoing traffic:

```bash
sudo ufw allow from 10.0.0.192 to any port 22  # allow specific IP
sudo ufw allow from 10.0.0.0/24 to any port 22  # allow a subnet
sudo ufw deny from 10.0.0.37  # deny a specific IP
sudo ufw delete deny 443/tcp # delete 443/tcp rule
```

Check numbered rules:

```bash
sudo ufw status numbered
```

Remove rules by index:

```bash
sudo ufw delete 1  # delete the first rule
```

### Step 3: Advanced UFW Configuration

To reorder rules, delete a rule and insert a new one:

```bash
sudo ufw delete 2  # delete the second rule
sudo ufw insert 1 deny from 10.0.0.37  # insert a deny rule at the top
```

## Testing Network Configuration

Check the current IP addresses and links:

```bash
ip a
ip -c link
```

Ping an external IP to test connectivity:

```bash
ping -c 4 8.8.8.8  # ping Google DNS
```

To block outgoing traffic to a specific address:

```bash
sudo ufw deny out on enp0s3 to 8.8.8.8  # deny outgoing traffic to Google DNS
```

To allow traffic between specific IPs:

```bash
sudo ufw allow in on enp0s3 from 10.0.0.192 to 10.0.0.100 proto tcp
sudo ufw allow out on enp0s3 from 10.0.0.100 to 10.0.0.192 proto tcp
```

Check UFW status after changes:

```bash
sudo ufw status numbered
```

## Network Security with IPTables and Firewalld

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

# Port Redirection and Network Address Translation (NAT)
Port redirection and NAT allow you to manage traffic between the internet and an internal network, enabling seamless communication and service access.

### Key Points

1. **Understanding NAT**:
   - Translates private IP addresses to a public one and vice versa.
   - Allows multiple devices on a local network to share a single public IP.

2. **Packet Structure**:
   - **Source IP Address**
   - **Data**
   - **Destination IP Address**
   - Example: A packet from `203.0.113.1` to `1.2.3.4` is rerouted to an internal server.

3. **Enabling Packet Forwarding**:
   - Modify sysctl configuration to allow packet forwarding:
     ```bash
     sudo vim /etc/sysctl.d/99-sysctl.conf
     net.ipv4.ip_forward=1
     sudo sysctl -p
     ```

4. **Configuring IP Tables**:
   - Set up NAT rules using `iptables`:
     ```bash
     sudo iptables -t nat -A PREROUTING -i enp1s0 -s 10.0.0.0/24 -p tcp --dport 8080 -j DNAT --to-destination 192.168.0.5:80
     sudo iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o enp6s0 -j MASQUERADE
     ```

5. **Persistence of Rules**:
   - Install `iptables-persistent` to ensure rules remain after reboots:
     ```bash
     sudo apt install iptables-persistent
     sudo netfilter-persistent save
     ```

6. **Firewall Configuration**:
   - Use UFW to manage firewall rules and allow necessary traffic:
     ```bash
     sudo ufw allow 22
     sudo ufw enable
     sudo ufw route allow from 10.0.0.0/24 to 192.168.0.5
     ```

7. **Flushing Rules**:
   - Reset iptables if errors occur:
     ```bash
     sudo iptables --flush --table nat
     ```

### Why Choose `iptables` Over `nftables`?

While `nftables` is the newer framework designed to replace `iptables`, there are compelling reasons to stick with `iptables` for certain scenarios:

1. **Maturity and Stability**:
   - `iptables` has been around for a long time, proving its reliability in various environments. It’s well-documented and widely used, making it easier to find support and resources.

2. **Simplicity**:
   - Many users find `iptables` commands straightforward and easier to remember, especially for common tasks. The syntax is often simpler for basic configurations.

3. **Existing Infrastructure**:
   - Many systems and scripts rely on `iptables`. Transitioning to `nftables` may require significant changes, which can be disruptive in established environments.

4. **Community Knowledge**:
   - The vast community and extensive documentation around `iptables` mean more resources for troubleshooting and configuration tips.

5. **Specific Use Cases**:
   - In certain scenarios, especially for legacy systems or specific applications, `iptables` may be the more appropriate choice due to its established presence and support.

### Conclusion

While `nftables` offers modern features and improvements, `iptables` remains a solid choice for many users due to its simplicity, maturity, and extensive community support. When configuring NAT and port forwarding, weigh your options carefully based on your specific environment and needs.

For further details on command usage and configurations, refer to:
```bash
man iptables
man ufw
``` 

By following these guidelines, you can effectively manage network traffic while leveraging the strengths of `iptables`.

# Implement Reverse Proxies and Load Balancers

When transitioning from a slow original web server to a new server, using a reverse proxy allows for seamless migration without the need for DNS propagation, which can take more than 24 hours. A reverse proxy can filter web traffic, cache content, and improve response times.

### Benefits of Load Balancers
- Distributes traffic across multiple web servers
- Dynamically selects servers based on load
- Ensures fair traffic distribution to enhance performance and reliability

## Prerequisites

- A server running a compatible Linux distribution
- NGINX installed (`sudo apt install nginx`)
- Basic knowledge of NGINX configuration

## Setting Up a Reverse Proxy

1. **Create a configuration file for the reverse proxy:**

   ```bash
   sudo vim /etc/nginx/sites-available/proxy.conf
   ```

   **Example Configuration:**

   ```conf
   server {
       listen 80;
       location /images { # example.com/images/ will be proxied
           proxy_pass http://1.1.1.1;
           include proxy_params;
       }
   }
   ```

2. **Set up proxy parameters:**

   ```bash
   cat /etc/nginx/proxy_params
   ```

   **Example Proxy Parameters:**

   ```conf
   proxy_set_header Host $http_host;
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   proxy_set_header X-Forwarded-Proto $scheme;
   ```

3. **Enable the reverse proxy site:**

   ```bash
   sudo ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
   ```

4. **Disable the default site:**

   ```bash
   sudo rm /etc/nginx/sites-enabled/default
   ```

## Configuring NGINX for Load Balancing

1. **Remove the existing proxy configuration:**

   ```bash
   sudo rm /etc/nginx/sites-enabled/proxy.conf
   ```

2. **Create a new configuration file for load balancing:**

   ```bash
   sudo vim /etc/nginx/sites-available/lb.conf
   ```

   **Example Load Balancer Configuration:**

   ```conf
   upstream mywebserver {
       least_conn;
       server 1.2.3.4 weight=3; # can bear more load
       server 5.6.7.8:8081; # custom port
       server 9.10.11.12 down; # temporarily down
       server 10.20.30.40 backup; # backup server
   }

   server {
       listen 80;
       location / {
           proxy_pass http://mywebserver;
       }
   }
   ```

3. **Enable the load balancer site:**

   ```bash
   sudo ln -s /etc/nginx/sites-available/lb.conf /etc/nginx/sites-enabled/lb.conf
   ```

## Testing and Reloading NGINX

1. **Test the configuration for errors:**

   ```bash
   sudo nginx -t
   ```

2. **If the configuration is successful, reload NGINX to apply changes:**

   ```bash
   sudo systemctl reload nginx.service
   ```
Setting up a reverse proxy and load balancer with NGINX improves web server efficiency and provides seamless traffic management. By following this guide, you can effectively transition between servers and optimize resource allocation.

# Set and Synchronize System Time Using Time Servers

This guide outlines the steps to set and synchronize your system time using NTP (Network Time Protocol) servers on Ubuntu. Ensuring accurate time is crucial for many applications and services, and system time may drift over time.

## Prerequisites

- Ubuntu system
- sudo privileges

## Overview of Time Management on Ubuntu

- **NTP (Network Time Protocol)**: A protocol designed to synchronize the clocks of computers over a network.
- **systemd-timesyncd**: The service responsible for time management on Ubuntu.

## Setting Up Your Time Zone

Before synchronizing your time, ensure that your system is set to the correct time zone. You can list available time zones and set the desired one using the `timedatectl` utility.

### List Available Time Zones

```bash
timedatectl list-timezones
```

### Set the Time Zone

Replace `America/Los_Angeles` with your desired time zone:

```bash
sudo timedatectl set-timezone America/Los_Angeles
```

### Verify Time and Time Zone

```bash
timedatectl
```

## Installing systemd-timesyncd

Make sure the `systemd-timesyncd` service is installed and enabled:

```bash
sudo apt install systemd-timesyncd
```

## Enable NTP Synchronization

To enable NTP synchronization:

```bash
sudo timedatectl set-ntp true
```

### Check Service Status

You can check the status of the time synchronization service:

```bash
systemctl status systemd-timesyncd.service
```

## Configuring NTP Servers

To configure which NTP servers to use, edit the `timesyncd.conf` file:

```bash
sudo vim /etc/systemd/timesyncd.conf
```

Add or modify the NTP lines:

```conf
NTP=0.us.pool.ntp.org 1.us.pool.ntp.org 2.us.pool.ntp.org 3.us.pool.ntp.org
```

### Restart the Service

After making changes, restart the service for the new settings to take effect:

```bash
sudo systemctl restart systemd-timesyncd
```

## Additional Commands

- To see available commands for `timedatectl`:

  ```bash
  timedatectl tab
  ```

- To view the current time synchronization status:

  ```bash
  timedatectl show-timesync
  ```

- To get detailed time synchronization status:

  ```bash
  timedatectl timesync-status
  ```

# SSH Configuration Guide
## Configure SSH Servers
### Server Configuration

1. **Open the SSH server configuration file:**
   ```bash
   sudo vim /etc/ssh/sshd_config
   ```

2. **Basic Configuration:**
   Update the configuration file with the following settings:
   ```conf
   # default port is 22
   # Port 123 # can change port
   AddressFamily any # inet: ipv4 and inet6: ipv6
   ListenAddress 192.145.23.2 # only accept from this IP
   PermitRootLogin no # root is not allowed
   PasswordAuthentication no # only SSH authentication
   KbdInteractiveAuthentication no # don't show password
   X11Forwarding yes # allow X11 forwarding

   Match User anoncvs
       PasswordAuthentication yes # only this user can use password for login 
   ```

3. **Reload SSH Service:**
   After making changes, reload the SSH service:
   ```bash
   sudo systemctl reload ssh.service
   ```

4. **Check Additional Configurations:**
   You may have additional configurations in:
   ```bash
   sudo cat /etc/ssh/sshd_config.d/50-cloud-init.conf # check for clashes
   ```

---

## User-Specific SSH Settings

1. **Open User SSH Configuration:**
   Navigate to your home directory and open the SSH config file:
   ```bash
   cd ~
   vim .ssh/config
   ```

2. **Add Host Configuration:**
   Add the following configuration for a specific host:
   ```conf
   Host ubuntu-vm
       HostName 10.0.0.186
       Port 22
       User jeremy
   ```

3. **Set Permissions:**
   Ensure the SSH config file has the correct permissions:
   ```bash
   chmod 600 ~/.ssh/config
   ```

4. **Connect to the Host:**
   You can now SSH into the configured host:
   ```bash
   ssh ubuntu-vm
   ```

---

## Global SSH Settings

1. **Open Global SSH Configuration:**
   Edit the global SSH configuration file:
   ```bash
   sudo vim /etc/ssh/ssh_config
   ```

2. **Global Configuration Example:**
   Add the following lines for global settings:
   ```conf
   Host *
       Port 229 # apply to all hosts
   ```

3. **Additional Configuration Files:**
   You can create additional config files under:
   ```bash
   sudo vim /etc/ssh/ssh_config.d/99-our-settings.conf
   ```

   Add global settings here:
   ```conf
   Port 229
   ```

---

## SSH Key Authentication

1. **Generate SSH Keys:**
   Use the following command to generate SSH keys:
   ```bash
   ssh-keygen
   ```

   This will create files in `/home/jeremy/.ssh/`:
   - `id_ed25519` (private key)
   - `id_ed25519.pub` (public key)

2. **Copy Public Key to Remote Host:**
   Use `ssh-copy-id` to copy your public key to the remote host:
   ```bash
   ssh-copy-id jeremy@10.0.0.173
   ```

3. **Connect to Remote Host:**
   SSH into the remote host using the command:
   ```bash
   ssh jeremy@10.0.0.173
   ```

4. **View Authorized Keys:**
   To verify your key was added, check the authorized keys:
   ```bash
   cat ~/.ssh/authorized_keys
   ```

---

## Managing Known Hosts

1. **Remove Old Fingerprints:**
   If you need to remove a specific old fingerprint, use:
   ```bash
   ssh-keygen -R 10.0.0.251
   ```

2. **Remove All Fingerprints:**
   To clear all fingerprints, you can remove the known hosts file:
   ```bash
   rm ~/.ssh/known_hosts
   ```
---

# List, Create, Delete, and Modify Physical Storage Partitions
To list partitions, you can use the following commands:

```bash
lsblk
lsblk -f # check disk with filesystem
ls /dev/sda1
ls /dev/sda  # Points to the entire device
sudo fdisk --list /dev/sda
```

### Viewing Partitions with cfdisk

To view and modify partitions interactively, use:

```bash
sudo cfdisk /dev/sdb
```

- **GPT**: Great Partition Table
- **DOS**: Equivalent to MBR in cfdisk

After making changes in cfdisk, remember to select the **Write** button to save the configuration.

## Create and Modify Partitions

1. Open `cfdisk` or `fdisk` for the desired disk.
2. Create or modify partitions as needed.
3. Always remember to write the changes.

## Delete Partitions

To delete a partition, follow these steps in `cfdisk` or similar tools:

1. Select the partition to delete.
2. Choose the delete option.
3. Write the changes to the disk.

## Configure and Manage Swap Space

### Check Current Swap Space

To view currently active swap space:

```bash
swapon --show
lsblk
```

### Create Swap Space

1. Create a new swap partition:

   ```bash
   sudo mkswap /dev/vdb3
   ```

2. Activate the new swap space:

   ```bash
   sudo swapon --verbose /dev/vdb3
   ```

3. Verify the new swap space:

   ```bash
   swapon --show
   ```

### Temporarily Disable Swap Space

To disable the swap space temporarily:

```bash
sudo swapoff /dev/vdb3
```

### Create a Swap File

To create a swap file instead of a swap partition:

```bash
sudo dd if=/dev/zero of=/swap bs=1M count=128  # 128 MB
sudo dd if=/dev/zero of=/swap bs=1M count=2048 status=progress  # 2 GB
sudo chmod 600 /swap  # Read/write only for owner
sudo mkswap /swap
sudo swapon --verbose /swap
swapon --show
```
---

# Create and Configure File Systems
## Supported File Systems

- **Red Hat:** XFS
- **Ubuntu:** ext4

### Creating File Systems

#### XFS on Red Hat

To create an XFS file system on a device (e.g., `/dev/sdb1`), use the following command:

```bash
sudo mkfs.xfs /dev/sdb1
```

For more detailed information about the XFS file system creation command, refer to the manual:

```bash
man mkfs.xfs
```

##### Advanced XFS Options

- Format the filesystem with a Label:
  ```bash
  sudo mkfs.xfs -L "BackupVolume" /dev/sdb1
  ```

- To specify the inode size:
  ```bash
  sudo mkfs.xfs -i size=512 /dev/sdb1
  ```

- To force the creation of the file system:
  ```bash
  sudo mkfs.xfs -f -i size=512 /dev/sdb1
  ```

- To label the file system while forcing creation:
  ```bash
  sudo mkfs.xfs -f -i size=512 -L "BackupVolume" /dev/sdb1
  ```

- To change the label of an existing XFS file system:
  ```bash
  sudo xfs_admin -l /dev/sdb1
  sudo xfs_admin -L "FirstFS" /dev/sdb1
  ```

#### ext4 on Ubuntu

To create an ext4 file system on a device (e.g., `/dev/sdb2`), use:

```bash
sudo mkfs.ext4 /dev/sdb2
```

For more information about the ext4 file system creation command, check the manual:

```bash
man mkfs.ext4
```

##### Advanced ext4 Options

- To create a file system with a specified number of inodes:
  ```bash
  sudo mkfs.ext4 -N 500000 /dev/sdb2
  ```

- To list file system parameters:
  ```bash
  sudo tune2fs -l /dev/sdb2
  ```

- To change the label of an ext4 file system:
  ```bash
  sudo tune2fs -L "SecondFS" /dev/sdb2
  ```

### Mounting File Systems

To mount a file system, you can use the following commands:

1. **Manual Mounting:**

   ```bash
   sudo mount /dev/vdb1 /mnt/
   ```

2. **Verify the Mount:**

   ```bash
   ls -l /mnt/
   lsblk
   ```

3. **Unmount the File System:**

   ```bash
   sudo umount /mnt/
   ```

### Persistent Mounting with fstab

To ensure your file system mounts automatically during boot, you'll need to edit the `/etc/fstab` file.

1. **Open the fstab file:**

   ```bash
   sudo vim /etc/fstab
   ```

2. **Add your mount configuration:**
   ```
   /dev/vda2   /boot   ext4   defaults   0  1
   ```

   The last two numbers control the order of file system checks at boot:
   - `0`: never scan the filesystem
   - `1`: scan the filesystem first
   - `2`: scan the filesystem later

3. **Reload systemd to apply changes:**

   ```bash
   sudo systemctl daemon-reload
   ```

4. **Verify the mount directory:**

   ```bash
   ls /mybackups/
   ```

5. **Reboot to test the fstab configuration:**

   ```bash
   sudo systemctl reboot
   ```

6. **Check your backups directory after reboot:**

   ```bash
   ls -l /mybackups/
   lsblk
   ```

### Working with UUIDs

You can also use UUIDs to mount file systems. To find the UUID of a device:

```bash
sudo blkid /dev/vdb1
```

Then use the UUID in your `/etc/fstab` file:

```
UUID=your-uuid-here /your/mountpoint ext4 defaults 0 0
```
# Filesystem and Mount Options
## Commands
### Finding Mounted Filesystems

- **List all mounted filesystems**:
  ```bash
  findmnt
  ```

- **List mounted filesystems of specific types (e.g., xfs, ext4)**:
  ```bash
  findmnt -t xfs,ext4
  ```

### Mount Options

- **Mount a filesystem as read-only**:
  ```bash
  sudo mount -o ro /dev/vdb2 /mnt
  ```

- **Find files of specific types**:
  ```bash
  find -t xfs,ext4
  ```

- **Mount a filesystem as read-only with additional options**:
  ```bash
  sudo mount -o ro,noexec,nosuid /dev/vdb2 /mnt
  ```

- **Remount a filesystem with different options**:
  ```bash
  sudo mount -o remount,rw,noexec,nosuid /dev/vdb2 /mnt
  ```

- **Unmount a filesystem**:
  ```bash
  sudo umount /dev/vdb1
  ```

- **Mount with a specific allocation size**:
  ```bash
  sudo mount -o allocsize=32k /dev/vdb1 /mybackups
  ```

## Mount Options Explained

- `rw`: Mounts the filesystem with read and write permissions.
- `ro`: Mounts the filesystem with read-only permissions.
- `noexec`: Prevents execution of any binaries on the mounted filesystem.
- `nosuid`: Ignores the set-user-identifier (SUID) and set-group-identifier (SGID) bits on executable files.
- `allocsize=32k`: Specifies the allocation size for the filesystem.

## Notes

- Always ensure that you have the necessary permissions to mount and unmount filesystems.
- Use caution when remounting or changing options on active filesystems, as it may affect system stability.

---
# Use Remote Filesystems: NFS
## Network Filesystem Protocol (NFS)
NFS allows you to share directories and files with others over a network. This guide outlines the steps to set up and use NFS on a Linux system.
### Installation
First, install the NFS kernel server:

```bash
sudo apt install nfs-kernel-server
```

### Configure NFS Server

Edit the exports file to specify which directories to share:

```bash
sudo vi /etc/exports
```

#### Example Configuration

```conf
# NFS Server - Exporting Directories to Share
/srv/homes  hostname1(rw,sync,no_subtree_check)  hostname2(ro,sync,no_subtree_check)
/src/homes: /nfs/disk1/backups
# Example host specifications:
# hostname: example or server1.server1.example.com or 10.0.0.9 or 10.0.16.0/24
```

To learn more about export options, use:

```bash
man exports
```

#### Share a Specific Directory

To share the `/etc` directory with read-only access:

```conf
/etc/ 127.0.0.0(ro)
```

### Apply Changes

After editing `/etc/exports`, run the following commands:

```bash
sudo exportfs -r  # Re-export all directories
sudo exportfs -v  # View the current exports
```

### Example Export Configurations

```conf
/etc   127.0.0.1(sync,wdelay,hide,no_subtree_check,sec=sys,ro,secure,root_squash,no_all_squash)
/etc *.example.com (ro,sync,no_subtree_check)  # Share with all .example.com hosts
/etc *(ro,sync,no_subtree_check)  # Share with any client
```

### Client Setup

On the client machine, install the NFS common package:

```bash
sudo apt install nfs-common
```

#### Mounting a Remote NFS Share

The general syntax for mounting a remote NFS share is:

```bash
sudo mount Ip_or_hostname_of_server:/path/to/remote/directory /path/to/local/directory
```

For example, to mount the `/etc` directory from the server with IP address `127.0.0.1` to your local `/mnt` directory, use:

```bash
sudo mount 127.0.0.1:/etc /mnt
# or
sudo mount server1:/etc /mnt
```

### Unmounting

To unmount the directory, use:

```bash
sudo umount /mnt
```

### Automount at Boot Time

To ensure that the NFS share is mounted automatically at boot time, edit the `/etc/fstab` file:

```bash
sudo vi /etc/fstab
```

Add the following line:

```fs
127.0.0.1:/etc /mnt nfs defaults 0 0
```
---
# Network Block Device (NBD) Setup and LVM Management
Network Block Devices (NBD) allow a client machine to use storage on a remote server as if it were a local block device. This is useful for managing storage across different servers and for leveraging LVM features.

### Block Devices Overview

- `/dev/sda` or `/dev/vda`: Block device
- `/dev/sda1` or `/dev/vda1`: First partition
- `/dev/nbd0`: Network Block Device (located on the server)

## NBD Server Configuration

1. **Install NBD Server:**
   ```bash
   sudo apt install nbd-server
   ```

2. **Edit the NBD Server Configuration:**
   ```bash
   sudo vim /etc/nbd-server/config
   ```
   Add the following configuration:
   ```ini
   includedir = /etc/nbd-server/conf.d
   allowlist = true
   [partition2]
       exportname=/dev/sda1
   ```

3. **Restart NBD Server:**
   ```bash
   sudo systemctl restart nbd-server.service
   ```

4. **Consult the Manual:**
   ```bash
   man 5 nbd-server
   ```

## NBD Client Configuration

1. **Install NBD Client:**
   ```bash
   sudo apt install nbd-client
   ```

2. **Load the NBD Kernel Module:**
   ```bash
   sudo modprobe nbd
   ```

3. **Autoload the NBD Module on Boot:**
   ```bash
   sudo vi /etc/modules-load.d/modules.conf
   ```
   Add:
   ```ini
   nbd
   ```

4. **Connect to the NBD Server:**
   ```bash
   sudo nbd-client 127.0.0.1 -N partition2 # Connects /dev/nbd0
   ```

5. **Mount the NBD Device:**
   ```bash
   sudo mount /dev/nbd0 /mnt
   ```

6. **Verify Mount:**
   ```bash
   ls /mnt
   ```

7. **Unmount the Device:**
   ```bash
   sudo umount /mnt
   ```

8. **List Block Devices:**
   ```bash
   lsblk
   ```

9. **Disconnect from NBD:**
   ```bash
   sudo nbd-client -d /dev/nbd0 # Disconnect
   ```

10. **List NBD Server Exports:**
    ```bash
    sudo nbd-client -l 127.0.0.1
    ```

## LVM Management

1. **Install LVM2:**
   ```bash
   sudo apt install lvm2
   ```

2. **Create Physical Volumes (PVs):**
   ```bash
   sudo pvcreate /dev/sdc /dev/sdd
   ```

3. **Display Physical Volumes:**
   ```bash
   sudo pvs
   ```

4. **Create a Volume Group (VG):**
   ```bash
   sudo vgcreate my_volume /dev/sdc /dev/sdd
   ```

5. **Extend the Volume Group:**
   ```bash
   sudo pvcreate /dev/sde
   sudo vgextend my_volume /dev/sde
   ```

6. **Reduce the Volume Group:**
   ```bash
   sudo vgreduce my_volume /dev/sde
   sudo pvremove /dev/sde
   ```

7. **Create Logical Volumes (LV):**
   ```bash
   sudo lvcreate --size 2G --name partition1 my_volume
   sudo lvcreate --size 6G --name partition2 my_volume
   ```

8. **Display Volume Groups and Logical Volumes:**
   ```bash
   sudo vgs
   sudo lvs
   ```

9. **Resize Logical Volumes:**
   ```bash
   sudo lvresize --size size_in_GB vg_name/lv_name
   sudo lvresize --size 2G my_volume/partition1 # Shrink volume
   ```

10. **Format the Logical Volume:**
    ```bash
    sudo mkfs.ext4 /dev/my_volume/partition1
    ```

11. **Resize the Filesystem:**
    ```bash
    sudo lvresize --resizefs --size 3G my_volume/partition1
    ```

12. **Remove Logical Volume:**
  ```bash
    sudo lvremove my_volume/partition1
  ```
---
This section provides instructions for creating a Level 1 RAID array using `mdadm`. A RAID 1 array mirrors data across two devices, providing redundancy and improved data reliability.

## Prerequisites
- Ensure you have two block devices available (e.g., `/dev/vdb` and `/dev/vdc`).
- `mdadm` must be installed on your system.

## Check Current RAID Status
To view the current status of RAID arrays on your system, run:
```bash
sudo cat /proc/mdstat
```

## Creating a RAID 1 Array
To create a Level 1 RAID array at `/dev/md0` with two devices, use the following command:

```bash
mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/vdb /dev/vdc
```

### Important Notes:
- You may receive a warning stating: 
  ```
  Note: this array has metadata at the start and may not be suitable as a boot device. If you plan to store '/boot' on this device please ensure that your boot-loader understands md/v1.x metadata, or use --metadata=0.90
  ```
- Confirm the creation of the array by responding `yes` when prompted.

### Example Output
You might see output similar to the following:
```
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.
```

## Verifying the RAID Array
After creation, verify that the RAID array is functioning correctly:
```bash
sudo cat /proc/mdstat
```
---
# Monitor Storage Performance
## Prerequisites

Ensure you have the following tools installed:

```bash
sudo apt install sysstat
```

### Key Tools

- **top, htop**: For monitoring system performance.
- **iostat**: To display I/O statistics.
- **pidstat**: To monitor individual process statistics.

## I/O Statistics

You can use `iostat` to gather various statistics about read/write operations and process IDs. Here are some commands to get you started:

```bash
iostat # Basic I/O statistics
iostat 1 # Update every second
iostat -d # Display only disk stats (no CPU)
iostat -h # Human-readable format
```

### Monitoring Specific Devices

To monitor specific devices or partitions:

```bash
iostat -p ALL # Display statistics for all individual partitions
iostat -p sda # Display stats for a specific partition
```

### Example Command

Run a simple I/O test using `dd`:

```bash
dd if=/dev/zero of=DELETEME bs=1 count=10000000 oflag=dsync &
```

To terminate the process:

- Graceful: `kill <pid>`
- Forceful: `kill -9 <pid>`

### Device Mapper Info

To check information on device mapper:

```bash
sudo dmsetup info /dev/dm-0
```
---

# Filesystem Permissions Management
This guide explores how to manage filesystem permissions effectively using standard commands, ACL (Access Control Lists), and `chattr` (file attributes). These tools are crucial when managing shared files between multiple users in a system.

## Scenario: Managing File Permissions for Multiple Users

In a shared environment, user `jeremy` needs write access to a file owned by another user `alex`. While traditional Linux permissions do not allow easy sharing without altering ownership, ACLs can provide fine-grained access control. Additionally, `chattr` can be used to further protect files from unauthorized modifications.

## Basic Commands

To begin, check the existing file permissions using:

```bash
ls -l
```

Example:

```bash
$ ls -l
-rw-rw-r-- 1 alex staff 25 May 23 06:18 file3
```

In this example, `alex` owns `file3` and has read/write access, while other users can only read the file.

## Working with ACLs

To solve the problem of granting Jeremy write permissions without disrupting Alex's rights, ACLs are used.

### Step 1: Install ACL

First, make sure ACLs are installed on your system:

```bash
sudo apt install acl
```

### Step 2: Set ACL for a User

Grant user `jeremy` write access to `file3`:

```bash
sudo setfacl --modify user:jeremy:rw file3
```

Now, `jeremy` has the same read/write permissions as the file owner without altering the file's original ownership. Jeremy can now edit the file:

```bash
$ echo "This is the NEW file content" > file3
$ cat file3
This is the NEW file content
```

### Step 3: View ACLs

To view ACLs set on the file:

```bash
getfacl file3
```

This will show the current ACLs, confirming that `jeremy` has been granted the necessary permissions.

---

## Modify and Remove ACLs

In certain cases, you may need to modify or remove ACLs.

### Modify Mask or Group Permissions:

```bash
sudo setfacl --modify mask:r file3
sudo setfacl --modify group:sudo:rw file3
```

### Remove User/Group ACLs:

To remove permissions for `jeremy`:

```bash
sudo setfacl --remove user:jeremy file3
```

To remove all ACL entries from the file:

```bash
sudo setfacl --remove-all file3
```

---

## Recursive ACL Management

Sometimes, you need to apply ACLs to entire directories. For example, to grant `jeremy` full access to a directory (`dir1`) and all its contents:

```bash
mkdir dir1
setfacl --recursive -m user:jeremy:rwx dir1/
```

To remove `jeremy`'s access recursively:

```bash
setfacl --recursive --remove user:jeremy dir1/
```

---

## File Attributes with `chattr`

`chattr` offers additional control over files, such as making them append-only or immutable.

### Scenario: Protecting Critical Files with `chattr`

In certain cases, you may want to protect a file from being overwritten or modified altogether. For example, `alex` wants to protect `file3` by making it append-only, so that new content can be added but existing content cannot be overwritten.

### Append-Only Files

To set `file3` as append-only:

```bash
echo "This is the file content" > file3
sudo chattr +a file3
```

Now, attempts to overwrite the file will fail:

```bash
$ echo "Overwrite content" > file3
-bash: file3: Operation not permitted
```

Appending content will still work:

```bash
$ echo "Append new content" >> file3
$ cat file3
This is the file content
Append new content
```

### Remove Append-Only Attribute

To remove the append-only protection:

```bash
sudo chattr -a file3
```

### Making a File Immutable

To prevent all modifications, set a file as immutable:

```bash
sudo chattr +i file3
```

Once immutable, no one (not even the file owner) can modify or delete the file:

```bash
$ echo "Try to modify" > file3
-bash: file3: Operation not permitted
```

### Remove Immutable Attribute

To remove immutability:

```bash
sudo chattr -i file3
```

---

## List File Attributes

To see the attributes of files (such as immutability or append-only):

```bash
lsattr
```

---

## Manual Pages

For more detailed information, consult the manual pages for ACL and attributes:

```bash
man acl
man attr
```
Using ACLs and `chattr`, system administrators can manage file access and protect critical files more effectively. ACLs allow for fine-grained permission control, while `chattr` can enforce stricter protections, such as preventing modifications to important system files. Together, these tools offer a powerful way to manage multi-user environments.
```