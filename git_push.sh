#!/bin/zsh
cd /home/khaleel/DevOPS
#git fetch 
#git pull
git add .
#git commit -m "terraform commit @ $(date +'%Y-%m-%d %H:%M:%S')"  
git commit -m  "Fedora ssh configurations@ $(date +'%Y-%m-%d %H:%M:%S')"
#git commit -m   "Ansible Commit @ $(date +'%Y-%m-%d %H:%M:%S')"0
git push -u origin master
