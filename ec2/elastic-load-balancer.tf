resource "aws_alb" "load-balancer" {
  name            = "${var.app_name}-lb"
  subnets         = ["${var.subnet_ids}"]
  security_groups = ["${aws_security_group.pace-lb-security-group.id}"]
}

resource "aws_security_group" "pace-lb-security-group" {
  name = "${var.app_name}-lb-security-group"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_alb_target_group" "pace-target_group" {
  name     = "${var.app_name}-target-group"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  depends_on = [ "aws_alb.load-balancer"]
  lifecycle {
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_target_group" "pace-pdf-target_group" {
  name     = "${var.app_name}-pdf-target-group"
  port     = "3001"
  protocol = "HTTP"
  vpc_id   = "${var.vpc_id}"
  depends_on = [ "aws_alb.load-balancer"]
  lifecycle {
    create_before_destroy = true
  }
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

data "aws_acm_certificate" "pace-cert"
{
  domain = "www.${var.domain_name}"
}

resource "aws_alb_listener" "alb-listener-https" {
  load_balancer_arn = "${aws_alb.load-balancer.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${data.aws_acm_certificate.pace-cert.arn}"
  default_action {
    target_group_arn = "${aws_alb_target_group.pace-target_group.arn}"
    type             = "forward"
  }
}
resource "aws_alb_listener" "alb-listener-http" {
  load_balancer_arn = "${aws_alb.load-balancer.arn}"
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"
    redirect {
      status_code = "HTTP_301"
      protocol    = "HTTPS"
      port        = "443"
    }
  }
}

resource "aws_lb_listener_rule" "pdf_listener" {
  listener_arn = "${aws_alb_listener.alb-listener-https.arn}"
  priority     = 100
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.pace-pdf-target_group.arn}"
  }
  condition {
    field  = "path-pattern"
    values = ["/pdf/*"]
  }
}

resource "aws_autoscaling_attachment" "pace-attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.ecs-autoscaling-group.name}"
  alb_target_group_arn = "${aws_alb_target_group.pace-target_group.arn}"
}

resource "aws_autoscaling_attachment" "pace-pdf-attachment" {
  autoscaling_group_name = "${aws_autoscaling_group.ecs-autoscaling-group.name}"
  alb_target_group_arn = "${aws_alb_target_group.pace-pdf-target_group.arn}"
}
output "load-balancer-dns-name" {
  value = "${aws_alb.load-balancer.dns_name}"
}

output "load-balancer-name" {
  value = "${aws_alb.load-balancer.name}"
}

output "load-balancer-security-group-id" {
  value = "${aws_security_group.pace-lb-security-group.id}"
}
