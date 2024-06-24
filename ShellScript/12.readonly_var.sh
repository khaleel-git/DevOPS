#!/bin/zsh

name="khaleel"
echo "${name}"

name="Ahmad"
unset name

echo "var name has been unset"
echo "name=${name}"

# now use readonly
readonly name="name is readonly"

name="can't update" # throws an error
echo "${name}"