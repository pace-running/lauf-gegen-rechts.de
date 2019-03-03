resource "aws_efs_file_system" "pdf-efs" {
  creation_token = "${var.app_name}-pdf-efs"
}

resource "aws_efs_mount_target" "pdf-efs-target-subnet-1" {
  file_system_id = "${aws_efs_file_system.pdf-efs.id}"
  subnet_id      = "${element(data.aws_subnet_ids.ec2_subnets.ids, 1)}"
}

resource "aws_efs_mount_target" "pdf-efs-target-subnet-2" {
  file_system_id = "${aws_efs_file_system.pdf-efs.id}"
  subnet_id      = "${element(data.aws_subnet_ids.ec2_subnets.ids, 2)}"
}

data "aws_subnet_ids" "ec2_subnets" {
  vpc_id = "${var.vpc-id}"

  tags {
    "Name" = "pace-ec2-subnet"
  }
}
