
kodekloud course link: https://learn.kodekloud.com/user/courses/learning-linux-basics-course-labs
 ## Package management
 .RPM -> RHEL, CentOS, Fedora
 .DEB -> Ubuntu, Debian, Linux Mint (DPKG)

 RedHAT(paid, support) vs CentOS (community driven, fork from redhat)

 Package: compress archive, software, contains all the files to function together e.g: gimp.deb package (binaries, metadata etc)
 install, trusted source, simplify, powerful querying option, remove, updating, managing dependancies, fix depency hell
 

 # Types of package
 dpkg -> apt -> apt-get
 rpm -> yum  (frontend for the rpm) -> dnf (more feautre rich)

# RPM
```
rmp -ivh telnet.rpm -> i: install, v: verbose, h: 
rpm -e telnet.rpm (uninstall)
rpm -Uvh telnet.rpm (add disccription here)
rpm -q telnet.rpm (query)
rpm -Vf (vefify)

# YUM -> yello dog updater modifier
high level of rpm, depencany very vell, 
/etc/yum.repos.d
/etc/yum.repos.d/redhat.repo
/etc/yum.repos.d/nginx.repo
```
apt is more advanced than apt-get, apt has progress bar, apt can search while apt-get cannot search and we have to use apt-cache to search a package



File Compression and Archival

du -sk test.img (size in KB)

du -sh test.img (MB)

ls -lh test.img

# aRchiving files
tar -cf  test.tar file1 file2 file 3

tar -xf (extract)
tar -zcf (reduce size, compress)

bzip2, gzip, xz (bunzip2, gunzip, unxz) - add short introductiona and example
zcat/bzcat/...cat (??)
```
bob@caleston-lp10:~$ tar -cf python.tar reptile/snake/python/
bob@caleston-lp10:~$ ls
amphibian  birds  mammals  media  python.tar  reptile
bob@caleston-lp10:~$ gzip python.tar
bob@caleston-lp10:~$ ls
amphibian  birds  mammals  media  python.tar.gz  reptile
bob@caleston-lp10:~$ 
```
# Searching for Files and Patterns
locate city.txt, downsize: depends on data base
updatedb then run locate command (root)

find /dir -name city.txt

## Search within file
cat sample.txt
search word:
grep second sample.txt (print only line matching, its case senstivie)
for case insentive grep -i
grep -r "third line" /home/michael -> search pattern recursively
grep -v "printed" sample.txt (ignore pattern)

grep -w exam example.txt (word matching)
grep -w & -v -> 

grep -A1 aresenal file.txt (one line extra)

grep -B1: print before matching line
grep -A and grep -B (combine)


# IO Rediraction
standard stream:
stdin 
stdout
stderror

echo $SHELL > shell.txt (overrite content)
echo $SHELL >> shell.txt (append)

Redirecto error messge:
cat missing_file 2> error.txt
cat missing_file 2>> error.txt

Dump anything we don't need, dont print on the screen
cat missing_file 2> /dev/null 


## Command line pipes
output of first command is the input of second command
grep Hello sampl.txt | less

Tee command (still printed on the screen)
echo $SHELL | tee shell.txt (overrite)

echo $SHELL | tee -a shell.txt (append)

