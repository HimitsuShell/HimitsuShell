#!/bin/sh

echo "0: $0"
echo "1: $1"
echo "2: $2"

echo "Alice 85 Bob 92 Charlie 78" | awk '{print $1, "score:", $2}'

