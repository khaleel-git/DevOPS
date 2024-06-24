#!/bin/zsh
echo this is Khaleel Ahmad # in line comment
echo 'this is our first                 shellscript' # one more comment
# this is an another comment in shell script.
# echo -e "\033[0;31m fail message # here" # this is one more comment
# echo -e "\033[0;32m success message #  here"
# echo -e "\033[0;33m warning message here"
echo "my
name
is
Khaleel"

echo "
############### Script Starting ##############
purpose: going to demonstrate comments
##############################################
"
# strong quotes.
echo 'my \
name \
is \
Khaleel'   # Escape character \ taken literally because of strong quoting.

echo " my \
name \
is \
Khaleel \
" # Newline escaped.
echo -e "this is Khaleel \t Ahmad \t test name"
echo -e "this is Khaleel \v Ahmad \v test name"
echo -e "this is Khaleel \n Ahmad \n test name"