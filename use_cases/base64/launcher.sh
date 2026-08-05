#!/bin/sh

echo "=== Base64 Test ==="

DATA="HimitsuShell"

ENC=$(echo -n "$DATA" | base64)

echo "Original: $DATA"
echo "Encoded: $ENC"