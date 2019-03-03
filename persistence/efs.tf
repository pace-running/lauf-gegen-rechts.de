resource "aws_efs_file_system" "pdf-efs" {
  creation_token = "${var.app_name}-pdf-efs"
}

resource "aws_efs_mount_target" "pdf-efs-target-subnet-1" {
  file_system_id  = "${aws_efs_file_system.pdf-efs.id}"
  subnet_id       = "${element(data.aws_subnet_ids.ec2_subnets.ids, 1)}"
  security_groups = ["${aws_security_group.efs-security-group.id}"]
}

resource "aws_efs_mount_target" "pdf-efs-target-subnet-2" {
  file_system_id  = "${aws_efs_file_system.pdf-efs.id}"
  subnet_id       = "${element(data.aws_subnet_ids.ec2_subnets.ids, 2)}"
  security_groups = ["${aws_security_group.efs-security-group.id}"]
}

data "aws_subnet_ids" "ec2_subnets" {
  vpc_id = "${var.vpc-id}"

  tags {
    "Name" = "pace-ec2-subnet"
  }
}

resource "aws_security_group" "efs-security-group" {
  name = "efs-security-group"

  description = "Allow access to EFS"
  vpc_id      = "${var.vpc-id}"

  # Only NFS in
  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = ["${var.security-group-id}"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
