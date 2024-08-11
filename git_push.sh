#!/bin/zsh
cd /home/khaleel/DevOPS
#git fetch 
#git pull
git add .
#git commit -m "terraform commit @ $(date +'%Y-%m-%d %H:%M:%S')"  
#git commit -m  "Ubuntu ssh configurations@ $(date +'%Y-%m-%d %H:%M:%S')"
git commit -m   "Commit @ $(date +'%Y-%m-%d %H:%M:%S')"
git push -u origin master
