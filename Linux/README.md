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

- 

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

 ## ownership (group)
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

