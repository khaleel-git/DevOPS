#!/bin/bash

echo "Arithmetic using double parenthesis i.e (())"

a=5
b=6
echo "a = $a, b = $b"

echo "a+b = $((a+b))"
echo "a-b = $((a-b))"
echo "a*b = $((a*b))"

res_div=$(echo "scale=2; $a / $b" | bc)
echo "a/b = $res_div" # 5/6

echo "a%b = $((a%b))"
echo "2pow3 = $((2**3))" # 2*2*2
((a++)) # a=a+1
echo "a++ or a=a+1 = $a"
((a+=3)) # a=a+3
echo "a+=3 or a=a+3 = $a"