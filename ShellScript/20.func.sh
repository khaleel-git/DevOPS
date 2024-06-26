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

# Prompt user for input
read -p "Enter first value: " a
read -p "Enter second value: " b

# Check if variables have been provided; show error message and set default values if not
if [ -z "$a" ]; then
    echo "Error: You didn't provide first value" >&2
    a=10  # Default value for a
    echo "First default value: $a"
fi

if [ -z "$b" ]; then
    echo "Error: You didn't provide second value" >&2
    b=20  # Default value for b
    echo "Second default value: $b"
fi

# Define function to calculate sum
sum() {
    echo "Script name is ${0}"
    echo "Entering ${FUNCNAME} function ..."
    local a="$1"
    local b="$2"
    echo "Sum is $((a + b))"
}

# Call sum function with provided or default values
sum "$a" "$b"