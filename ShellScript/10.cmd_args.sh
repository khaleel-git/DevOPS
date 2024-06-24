#!/bin/zsh
name=${1}
age=${2}
height=${3}
echo ${0}
echo ${4}
echo ${5}
echo "my name is ${name}, and my age is ${age}, and my height is ${height}"
echo $# # prints only passed args
echo $@ # prints all args as a separate words
echo $* # prints all args as a single words