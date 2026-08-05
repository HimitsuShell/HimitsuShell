#!/bin/sh

echo "=== Pipeline Test ==="

echo "apple
banana
orange
apple" | sort | uniq -c