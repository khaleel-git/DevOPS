#!/bin/zsh
#cd /home/khaleel/DevOPS
cd /home/khaleel/DevOPS/Git
#git fetch 
#git pull
git add .
git commit -m "$(date +'%Y-%m-%d %H:%M:%S')"  
git push -u origin master
