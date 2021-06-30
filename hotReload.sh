#!/bin/bash

fswatch -o . | xargs -I {} tflint
