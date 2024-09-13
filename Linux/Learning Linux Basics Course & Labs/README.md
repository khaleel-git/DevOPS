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

## Vim Editor
update-alternatives --display editor: check default editors
- **Basic Commands**:
  - **Open file**:
    ```bash
    vim filename
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

    x: remove a letter
    yy: copy a line
    p: paste a line
    dd: cut or delte
    d3d: delete first 3 lines
    u: undo
    ctr + r: redo

    insert mode: AIOaio


# Networking



For more details and practical examples, check out the [KodeKloud Linux Basics Course](https://learn.kodekloud.com/user/courses/learning-linux-basics-course-labs).
Happy Learning!

