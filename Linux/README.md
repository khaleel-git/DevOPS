# Linux Boot Process
![Linux Boot Process](How-linux-boot.png)
[Watch the Linux Boot Process Video](https://www.youtube.com/watch?v=XpFsMB6FoOs&ab_channel=ByteByteGo)

Linux login, cli and gui
console (linux boot console), virtual terminal (ctrl+alt+f2 open vertual terminal, its a run level 3 , terminal emulator (grphical emulator terminal)
Remote GUI: vnc, rdp
ssh: open ssh daemon (secure shell), use strong encryption
telnet (highly insecure)
ip a

 cat /etc/*release*

 Read and Use System Documentation
journalctl --help
man journalctl
 man man
 man 1 printf
 man 3 printf
 apropos director # search throuh man pages, relies on database 
 sudo mandb
 apropos -s 1,8 director

 man grep
 command tab tab
 quickly look for help with --help or man page
 man ssh
 ssh -V

Create, Delete, Copy, and Move Files and Directories
 ls -lah (l=detail, a=all, h=humand readable format)
 cd / (go to root dir)
 cd - (go to previous dir)
cd ~ or cd (go to home dir)
cd .. (move one dir up)

inod kep track of blocks of data, links: 1
hard link to dog.jpg will have all the content under ionod
 ## Hard link (copy all the content, if source data is 2G then we have to copy 2G more to the destination i.e hard link)
 ln path_to_target_file path_to_link_file (hard link, point to same inode, only file)
 same as: cp path

 useradd -a -G family aaron
 useradd -a -G family jane
 chmod 660 /home/aaron/Pictures/family_dog.jpg

 ## Soft Link
 folder to folder, file to file, its a shortcut
 ln -s target_file link_file

 ## Copy with preserve
 `cp --preserve /home/bob/myfile.txt /home/bob/data/myfile.txt`

 ## mov
 do not add -r (recursive) in mov attribute

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

