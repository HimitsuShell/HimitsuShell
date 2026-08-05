#!/bin/sh

echo "0: $0"
echo "1: $1"

if [ "$1" = "hello" ]; then
    echo "Hello world!"
else
    echo "Unknown input"
fi