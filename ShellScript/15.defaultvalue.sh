#!/bin/bash
#!/bin/zsh # it will be skipped. only first line shebang is functional
read -p " please enter your name " name

name=${name:-World}

echo "Hello ${name^}"

yourname=${unsetvariable-Ahmad}
echo $yourname

myname=""
mytestname=${myname:-kali}
echo ${mytestname}