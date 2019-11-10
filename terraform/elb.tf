resource "aws_lb" "backend" {
  name = "backend"
  internal = false
  load_balancer_type = "application"
  security_groups = ["${aws_security_group.lb.id}"]
  subnets = [aws_subnet.public-a.id, aws_subnet.public-b.id]
  idle_timeout = 900

  access_logs {
    enabled = true
    bucket = aws_s3_bucket.backend-lb-logs.id
  }
}

resource "aws_s3_bucket" "backend-lb-logs" {
  bucket = "backend-elblogs"
  acl = "private"
  force_destroy = false
}

resource "aws_lb_target_group" "backend" {
  name = "backend"
  port = var.backend_port
  protocol = "HTTP"
  deregistration_delay = 30
  vpc_id = aws_vpc.main.id
  target_type = "ip"

  health_check {
    enabled = true
    healthy_threshold = 5
    interval = 30
    matcher = "200"
    path = "/api/status"
    port = "traffic-port"
    protocol = "HTTP"
    timeout = 5
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = "${aws_lb.backend.arn}"
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = "${aws_lb_target_group.backend.arn}"
  }

}

resource "aws_s3_bucket_policy" "backend-lb-logs" {
  bucket = "${aws_s3_bucket.backend-lb-logs.id}"

  policy = <<EOF
{
    "Id": "AccessLogsPolicy",
    "Statement": [{
            "Action": "s3:PutObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${var.elb_account_id}:root"
            },
            "Resource": "${aws_s3_bucket.backend-lb-logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Sid": "AllowWriteFromLoadBalancerAccount"
        },
        {
            "Action": "s3:PutObject",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            },
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Resource": "${aws_s3_bucket.backend-lb-logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
            "Sid": "AWSLogDeliveryWrite"
        },
        {
            "Action": "s3:GetBucketAcl",
            "Effect": "Allow",
            "Principal": {
                "Service": "delivery.logs.amazonaws.com"
            },
            "Resource": "${aws_s3_bucket.backend-lb-logs.arn}",
            "Sid": "AWSLogDeliveryAclCheck"
        }
    ],
    "Version": "2012-10-17"
}
EOF
}
