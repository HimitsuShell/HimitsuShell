#!/bin/bash

# shell CRLF -> LF
sed -i 's/\r$//' ./launcher.sh

# Generate secret key, expire date
rm -rf  ./key_01 ./key_02 ./key_03 ./iv_01 ./iv_02 ./iv_03 ./exp.bin
openssl rand -hex 32 | tr -d '\n' > ./key_01
openssl rand -hex 32 | tr -d '\n' > ./key_02
openssl rand -hex 32 | tr -d '\n' > ./key_03
openssl rand -hex 16 | tr -d '\n' > ./iv_01
openssl rand -hex 16 | tr -d '\n' > ./iv_02
openssl rand -hex 16 | tr -d '\n' > ./iv_03
perl -e 'print pack("Q<", `date -d "2099-01-01" +%s`)' > ./exp.bin

# Two-way encryption
rm -rf ./launcher.sh.enc ./exp.bin.enc ./key_01.enc ./iv_01.enc ./key_02.enc ./iv_02.enc
openssl enc -aes-256-ctr -nosalt -K "$(cat ./key_01)" -iv "$(cat ./iv_01)" -in ./launcher.sh -out ./launcher.sh.enc
openssl enc -aes-256-cbc -nosalt -K "$(cat ./key_02)" -iv "$(cat ./iv_02)" -in ./exp.bin -out ./exp.bin.enc
openssl enc -aes-256-cbc -nosalt -K "$(cat ./key_02)" -iv "$(cat ./iv_02)" -in ./key_01 -out ./key_01.enc
openssl enc -aes-256-cbc -nosalt -K "$(cat ./key_02)" -iv "$(cat ./iv_02)" -in ./iv_01 -out ./iv_01.enc
openssl enc -aes-256-cbc -nosalt -K "$(cat ./key_03)" -iv "$(cat ./iv_03)" -in ./key_02 -out ./key_02.enc
openssl enc -aes-256-cbc -nosalt -K "$(cat ./key_03)" -iv "$(cat ./iv_03)" -in ./iv_02 -out ./iv_02.enc
rm -rf  ./launcher.sh ./exp.bin ./key_01 ./iv_01 ./key_02 ./iv_02

# Converting to a C binary array
rm -rf xxd_data.c
echo '#include "xxd_data.h"' > xxd_data.c
for file in ./launcher.sh.enc ./exp.bin.enc ./key_01.enc ./iv_01.enc ./key_02.enc ./iv_02.enc ./key_03 ./iv_03; do
  xxd -i "$file" >> xxd_data.c
done
rm -rf ./launcher.sh.enc ./exp.bin.enc ./key_01.enc ./iv_01.enc ./key_02.enc ./iv_02.enc ./key_03 ./iv_03

# Linking Encrypted Data
rm -rf safeLauncher
BUILD="/var/work/compiler/bin/clang $TARGET_FLAG -static -O2 -s -fuse-ld=lld -mllvm -inline-threshold=500 \
-mllvm -sobf -mllvm -sub \
-Wall -Wundef -Werror=implicit-function-declaration -Wno-char-subscripts -Wno-pointer-sign -funsigned-char -Wno-string-plus-int -Wno-invalid-source-encoding -I . \
-fvisibility=hidden -fno-ident -ffunction-sections -fdata-sections -fno-asynchronous-unwind-tables -fno-strict-aliasing"
LINK="\
-Wl,--gc-sections -Wl,--as-needed \
-Wl,--shuffle-sections=.text.*=`shuf -i 1-9999999 -n 1` \
-Wl,--shuffle-sections=.data.*=`shuf -i 1-9999999 -n 1` \
-Wl,--shuffle-sections=.rodata.*=`shuf -i 1-9999999 -n 1`"
$BUILD lib.bc xxd_data.c $LINK -o safeLauncher
rm -rf xxd_data.c