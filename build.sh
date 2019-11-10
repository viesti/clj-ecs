#!/bin/bash

clj -A:pack \
    -m mach.pack.alpha.jib \
    --image-name 678497885140.dkr.ecr.eu-west-1.amazonaws.com/backend:2 \
    --image-type registry \
    -m clj-ecs.core
