#!/bin/bash

x=10
y=3

let "z = $(( x * y ))"  # multiplication
echo $z
let z=$((x*y))
echo $z

let "z = $(( x / y ))"  # division
echo $z
let z=$((x/y))
echo $z