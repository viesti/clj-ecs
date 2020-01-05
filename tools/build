#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR/..

GIT_SHA=$(git rev-parse --short HEAD)
clj -A:pack \
    -m mach.pack.alpha.jib \
    --image-name 678497885140.dkr.ecr.eu-west-1.amazonaws.com/backend:$GIT_SHA \
    --image-type registry \
    -m clj-ecs.core
