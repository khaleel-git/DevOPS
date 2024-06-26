#!/bin/bash

echo "Arithmetic using double parenthesis i.e (())"

a=5
b=6
echo "$((a+b))"
echo "$((a-b))"
echo "$((a*b))"
echo "$((a/b))" # 5/6
echo "$((a%b))"
echo "$((2**3))" # 2*2*2
((a++)) # a=a+1
echo $a
((a+=3)) # a=a+3
echo $a