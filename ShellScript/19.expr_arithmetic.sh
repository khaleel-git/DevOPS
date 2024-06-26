#!/bin/bash
a=10
b=3

# there must be spaces before/after the operator
sum=`expr $a + $b`
echo $sum

sum=`expr $a+$b` # concatenate only
echo "Concatenate if you dont add spaces: $sum"

sub=`expr $a - $b`
echo $sub

mul=`expr $a \* $b`
echo $mul

div=`expr $a / $b`
echo $div