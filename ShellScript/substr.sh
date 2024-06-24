#!/bin/bash

string="abcgauravabcxyz"

echo "${string:0}"
echo "${string:1}"
echo "${string:4}"
echo "${string:0:3}"
echo "${string:3:3}"
echo "${string: -5}"

echo "${string#a*c}"  # from starting, shortest match
echo "${string##a*c}" # from starting, longest match

echo ${string%b*z}  # from ending, shortest match
echo "${string%%b*z}" # from ending, longest match

string="abcgauravabcxyz"

echo "${string/abc/xyz}"
echo "${string//abc/xyz}"

echo "${string/abc}"
echo "${string//abc}"