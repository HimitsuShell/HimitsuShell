#!/bin/sh

FILE="test.txt"

echo "Hello HimitsuShell" > "$FILE"

if [ -f "$FILE" ]; then
    echo "File created"
    cat "$FILE"
fi

rm "$FILE"

echo "Cleanup done"