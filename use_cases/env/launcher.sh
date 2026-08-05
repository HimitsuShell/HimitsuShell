#!/bin/sh

echo "=== Environment Test ==="

echo "HOME: $HOME"
echo "USER: $USER"
echo "SHELL: $SHELL"

if [ -n "$PATH" ]; then
    echo "PATH exists"
fi