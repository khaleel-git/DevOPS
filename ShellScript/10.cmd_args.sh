#!/bin/zsh
name=${1}
age=${2}
height=${3}
echo ${0}
echo ${4}
echo ${5}
echo "my name is ${name}, and my age is ${age}, and my height is ${height}"

echo 'printing output of $#' # strong quote
echo $# # prints only passed args
echo -e "\n"

echo 'printing output of $@' # strong quote
echo $@ # prints all args as a separate words
echo -e "\n"

echo 'printing output of ${@}' # strong quote
echo ${@}
echo -e "\n"

echo 'printing output of $*' # strong quote
echo $* # prints all args as a single words
echo -e "\n"

echo 'printing output of ${*}' # strong quote
echo ${*}
echo -e "\n"