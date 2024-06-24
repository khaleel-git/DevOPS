#!/bin/zsh

echo "Converting str into Uppercase"
str="my name is khaleel"
echo "${str}"
echo "${str^}"    # only uppercase first letter
echo "${str^^}"   # convert whole str into uppercase

echo "Converting str into lowercase"
str = "KHALEEL AHMAD"
echo "${str,}"  # only first letter
echo "${str,,}" # convert completley


echo "Gettin a lenght of a str"
echo "$str lengths is: ${#str}"