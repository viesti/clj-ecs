#!/bin/bash

GIT_SHA=$(git rev-parse --short HEAD)
COMMAND=${1:-apply}
terraform $COMMAND -var git_sha=$GIT_SHA
