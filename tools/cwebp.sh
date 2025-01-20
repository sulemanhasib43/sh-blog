#!/usr/bin/env bash

input_file="$1"
output_file="${input_file%.*}.webp"
cwebp -q 75 "$input_file" -o "$output_file"
rm $1
