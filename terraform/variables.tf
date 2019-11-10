variable "elb_account_id" {
  description = "ID of the AWS ELB Account, from which access logs are written to S3."
  default     = 156460612806
}

variable "backend_port" {
  description = "Port on which to run the backend"
  default     = 4000
}

variable "backend_tag" {
  description = "Docker image tag of the backend to deploy"
}
