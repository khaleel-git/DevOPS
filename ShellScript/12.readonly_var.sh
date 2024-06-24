#!/bin/zsh

name="khaleel"
echo "${name}"

name="Ahmad"
unset name

echo "var name has been unset"
echo "${name}"

# now use readonly
readonly name="khaleel"

name="can't update"
echo "${name}"