#!/bin/zsh

echo "Please Enter your name: " 
read name

echo "Please Enter your age: "
read age

# echo "Getting input without explicitly using assigning values to variables, in this case REPLAY variable will be used."
# read
# echo $REPLAY

echo "Please enter your password: "
read -s password

echo "My name is ${name} and my age is ${age} and my password is ${password}"