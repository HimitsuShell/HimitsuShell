#!/bin/sh

# syntax error
# echo "--- bash: for array ---"
# fruits=("apple" "banana" "cherry"); for fruit in "${fruits[@]}"; do echo "Fruit: $fruit"; done

# syntax
echo "--- sh: if ---"
if [ "hello" = "hello" ]; then echo "Hello world!"; else echo "Unknown input"; fi

echo "--- sh: for ---"
for i in 1 2; do echo "Number: $i"; done

echo "--- bash: if ---"
if [[ "bye" == "hello" ]]; then echo "Hello world!"; elif (( 13 > 10 )); then echo "Number is greater than 10"; fi

echo "--- argument_passing ---"
echo "0: $0 | 1: $1 | 2: $2"

# cli
echo "--- awk ---"
echo "Alice 85 Bob 92 Charlie 78" | awk '{print $1, "score:", $2}'

echo "--- base64 ---"
echo $(echo -n "hello" | base64)

echo "--- basename ---"
basename /var/work

echo "--- cal ---"
cal

echo "--- cat ---"
echo "hello." | cat > cat.txt
if [ -f "cat.txt" ]; then cat cat.txt; fi

echo "--- env ---"
echo "HOME: $HOME | USER: $USER | SHELL: $SHELL | PATH: $PATH"

echo "--- funciton ---"
greet() { echo "$1"; }
greet Alice

echo "--- file (ls, mkdir, mv, rm) ---"
mkdir test_dir
mv test_dir test_dir_mv
rm -rf cat.txt test_dir_mv
ls -la

echo "--- math ---"
echo "10 + 3 * 2 = $((10 + 3 * 2))"

echo "--- pipeline ---"
echo "apple banana orange apple" | tr ' ' '\n' | sort | uniq -c

echo "--- pwd ---"
pwd

echo "--- string ---"
TEXT="hello"
echo -e "Length: ${#TEXT} | Upper: ${TEXT^^} | Replace: ${TEXT/hello/bye}"

echo "--- system ---"
echo "Date: $(date)"
echo "Random: $RANDOM"
echo "PID: $$"
echo "Uname: $(uname)"

echo "--- trap ---"
trap 'echo "Interrupted"; exit 1' INT
echo "Press Ctrl+C"
while true; do sleep 1; done