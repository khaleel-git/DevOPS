#!/bin/zsh

name="khaleel"
echo "${name}

name="Ahmad"
unset name
echo "${name}

# now use readonly
readonly name="khaleel"

name="can't update"
echo "${name}