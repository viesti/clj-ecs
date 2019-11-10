#!/bin/bash

GIT_SHA=$(git rev-parse --short HEAD)
terraform apply -var git_sha=$GIT_SHA
