# Git
Git vs Github (Local vs Remote)

Source Code Management System

Working Area
Staging Area
Commited Files

git restore file.txt (restore from modified state to destroy)
git restore --staged file.txt (move out file.txt from stagging area to modified state)
git rm --cached or git rm -force
git log -n 5 --oneline
git log -n 5
git log
git log --name-only (name committed files)
git log --graph --decorate # which branch is created after which

Git Branches
What is a branch in git? # pointer to a specific commit in git

git checkout -b sarah # barances are pointers to new commit
git branch new-name
git checkout sarah
git checkout -b max # create new and checkout immediately
git branch -d max # delete
git branch # list

# HEAD:
where is you at right now in the git repository
it points to the last commit in the branch you are currently on
head switches with switching branch # git checkout feature/signup

git commit -am 'Update file' will stage and commit it directly.
vs
git add newfile.txt
git commit -m 'Add new file'

# Initialize Remote Repositories
git remote add origin https://github.com/git-repo-url
git remote -v # lsit all remote repo

Pushing to remote repositories
git push origin master

Cloning remote repositories
git clone url

# git config
max (master)$ git config --global user.email 'max@example.com'
max (master)$ git config --global user.name

# github
Pull Requests
request other team members to approve my pr requests

# git reset/undo last commit
max (master)$ git reset --soft HEAD~1
