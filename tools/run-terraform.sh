#!/bin/bash

GIT_SHA=$(git rev-parse --short HEAD)
COMMAND=${1:-apply}
PROJECT=$(basename $PWD)

case $COMMAND in
    init)
        terraform init \
                  -backend-config="key=$PROJECT.tfstate"
        ;;
    *)
        terraform $COMMAND
        ;;
esac
