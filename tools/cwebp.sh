#!/usr/bin/env bash

input_file="$1"
output_file="${input_file%.*}.webp"
image_dir="assets/img/"
cwebp -q 75 "${image_dir}${input_file}" -o "${image_dir}${output_file}"
if [[ "${input_file##*.}" != "webp" ]]; then
  rm "${image_dir}${input_file}"
fi
