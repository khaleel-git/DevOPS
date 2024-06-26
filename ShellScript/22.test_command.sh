#!/bin/bash

echo "hello world"
# Status
echo $? # print the last run command status

a=5
test $a -eq 4
echo $?


test $a -eq 5
echo $?
