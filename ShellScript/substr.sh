#!/bin/bash

str="khaleelahmadisadevopsengineer"

echo "${str:0}"
echo "${str:1}"
echo "${str:4}"
echo "${str:0:3}"
echo "${str:3:3}"
echo "${str: -5}"

echo "${str#a*c}"  #  starting, shortest match
echo "${str##a*c}" #  starting, longest match

echo ${str%b*z}    #  ending, shortest match
echo "${str%%b*z}" #  ending, longest match

str="abcgauravabcxyz"

echo "${str/abc/xyz}"
echo "${str//abc/xyz}"

echo "${str/abc}"
echo "${str//abc}"