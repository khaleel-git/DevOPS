#!/bin/zsh
# System define variables.
echo ${SHELL}
echo ${HOME} # will show the home directory of current user
echo ${OSTYPE} # type type of operating system.
echo $PATH # A list of directories to be searched when executing commands.
echo ${$} # process id
echo ${PPID} # parent process id

echo $PWD # present working directory
echo $HOSTNAME # hostname of machine.
echo $UID # user id
# UID="5000" # variable UID is readonly
echo $UID
sleep 50
echo ${SECONDS}