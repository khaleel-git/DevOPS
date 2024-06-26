#!/bin/bash

# funtions
function install(){
  #### installations code.
  echo "installationscode1"
}
configuration(){
  # configurations code
  echo "configcode1"
}

function deploy {
  # deploy code.
  echo "deploy code 1"
}
configuration
install
deploy

read -p "enter first value: " a
read -p "enter second value: " b

a=""
b=""

: ${a:?" You didn't provide first value"}
echo "You provided first value: $a"

a=${a:-10}
b=${b:-20}



sum(){
    local a=$1
    local b=$2
    echo "Sum is $(( a + b))"
}

sum "$a" "$b"