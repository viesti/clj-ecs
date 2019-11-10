#!/bin/bash

GIT_SHA=$(git rev-parse --short HEAD)
terraform apply -var backend_tag=$GIT_SHA
