#!/bin/sh

trap 'echo "Interrupted"; exit 1' INT

echo "Press Ctrl+C"

while true
do
    sleep 1
done