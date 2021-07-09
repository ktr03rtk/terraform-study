#!/bin/sh

terraform init -input=false -no-color
terraform plan -input=false -no-color | tfnotify --confit ${CODEBUILD_SRC_DIR}/tfnotify.yml plan --message "$(date)"
