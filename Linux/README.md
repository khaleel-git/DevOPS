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
   sudo vi /etc/sysctl.d/swap-less.conf
   ```

   Add the following line to set the `vm.swappiness` parameter:

   ```plaintext
   vm.swappiness=60
   ```

2. **Load the changes immediately**:

   ```bash
   sudo sysctl -p /etc/sysctl.d/swap-less.conf
   ```

3. **To view specific parameters, you can use**:

   ```bash
   sysctl -a | grep vm
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

## Example: Adjusting Swappiness

Swappiness controls the tendency of the kernel to move processes out of physical memory and into swap. A higher value favors swapping, while a lower value minimizes it.

1. **Set swappiness to 60** (default):

   ```plaintext
   vm.swappiness=60
   ```

2. **Create or edit a config file**:

   ```bash
   sudo vi /etc/sysctl.d/swap-less.conf
   ```

3. **Load the changes**:

   ```bash
   sudo sysctl -p /etc/sysctl.d/swap-less.conf
   ```

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

## Manage User Privileges

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
