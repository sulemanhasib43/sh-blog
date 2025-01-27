#!/usr/bin/env bash

input_file="$1"
output_file="${input_file%.*}.webp"
# image_dir="assets/img/"
cwebp -q 75 "${input_file}" -o "${output_file}"
if [[ "${input_file##*.}" != "webp" ]]; then
  rm "${input_file}"
fi
