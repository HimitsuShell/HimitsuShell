#!/bin/sh

echo "=== String Test ==="

TEXT="HimitsuShell"

echo "Length: ${#TEXT}"
echo "Upper: ${TEXT^^}"
echo "Replace: ${TEXT/Shell/Binary}"