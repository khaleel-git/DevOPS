#!/bin/bash

str="khaleelahmadisadevopsengineer"

echo "${str:0}"    # print complete str
echo "${str:1}"    # print all except 0th place
echo "${str:4}"    # print all starting from 4th character
echo "${str:0:3}"
echo "${str:3:3}"
echo "${str: -5}"  # with space    -> print 5 characters starting from last character
echo "${str:-5}"   # without space -> don't perform substr operation (print all)

echo "${str#a*c}"  #  starting, shortest match -> remove a to c, then shortest match print
echo "${str##a*c}" #  starting, longest match  -> remove a to c, then longest match print

echo ${str%b*z}    #  ending, shortest match
echo "${str%%b*z}" #  ending, longest match

str="abcgauravabcxyz" # new string

echo "${str/abc/xyz}"
echo "${str//abc/xyz}"

echo "${str/abc}"
echo "${str//abc}"