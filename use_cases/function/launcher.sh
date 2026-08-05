#!/bin/sh

function greet() {
    echo "Hello $1"
}

for name in Alice Bob Charlie
do
    greet "$name"
done