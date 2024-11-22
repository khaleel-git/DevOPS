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

# Fetching and merging
git fetch origin master # update origin master
git merge origin/master

# direclty merging from remote to local
git pull origin master

# rebasing
git rebase master

# interactive rebasing
git rebase -i HEAD~4

# Cherry Picking
git chery-pick hash-of-the-commit

# Resetting and Reverting
git revert 8ad5d

# reset
git reset --soft HEAD~1
git reset --hard HEAD~1 # save no changes
git reset

# Stashing
git stash
git stash pop
git stash list
git stash show stash@{1}
git stash pop stash@{2}

# Reflog
git reflog

Porcelain commands (easy to remember)
git add
git status
git commit
git stash

Plumbing commands (internals of git)
git hash-object
git ls-files
git rev-parse
git ls-remote


git hash-object first_story.txt
bea8d7fee8e7b11c2235ca623935e6ccccd8bac3
key: be, value: a8d7fee8e7b11c2235ca623935e6ccccd8bac3

git add first.txt
git commit -m "first story"
ls ./.git/objects
26  be  a0  info    pack # be is a folder
ls ./.git/objects/be
a8d7fe..... # is the value and # be is the key

git cat-file -p bea8d7 # content 
git cat-file -p 4cdf4 # commit
tree 2ea7de...
parent f4e8304...
author: Lydia Hallie <e@mail.com> 159...
commiter Lydia Hallie ....

# Git Object Contents
commit
tree
blob

# First commit
blob

every commit points to the parent commit

## Resolving conflicts:
The content between <<<<<<< HEAD and ======= represents your local changes, 
while the content between ======= and >>>>>>> origin/master represents the changes from the remote branch.

update the file and commit it. It will resolve the conflicts.
