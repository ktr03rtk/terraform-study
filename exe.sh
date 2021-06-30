#!/bin/bash

cd "$(dirname "$0")" || exit 1

find . -type f -name '*.tf' -exec dirname {} \; | sort -u | xargs -n 1 tflint

echo -e "---------------------------------------------------------"
