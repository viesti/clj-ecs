# Terraform Fargate service for a Clojure app

Provides and example of a AWS Architecture for running a ECS service. The app provided in the repo is a JVM/Clojure application, built into Docker image via [pack.alpha](https://github.com/juxt/pack.alpha#docker-image)

## Architecture

The AWS architecture is created via Terraform by two modules

* [common](terraform/common)
  VPC with public (for ALB) and private (for backends) subnets
* [backend](terraform/backend)
  A ECS service with a load balancer
  
![Architecture picture](architecture.png)
