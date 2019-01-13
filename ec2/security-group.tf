resource "aws_security_group" "pace-ec2-security-group" {
  name = "${var.app_name}-ec2-security-group"
  vpc_id = "${var.vpc_id}"
  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_groups = ["${aws_security_group.pace-lb-security-group.id}"]
  }
   ingress {
    from_port = 3001
    to_port = 3001
    protocol = "tcp"
    security_groups = ["${aws_security_group.pace-lb-security-group.id}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}


output "ec2-security-group-id" {
  value = "${aws_security_group.pace-ec2-security-group.id}"
}