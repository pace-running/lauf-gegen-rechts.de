data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "pace-launch-configuration" {
  name_prefix                 = "pace-launch-configuration"
  image_id                    = "${data.aws_ami.ubuntu.id}"
  instance_type               = "t2.medium"
  associate_public_ip_address = "true"
  user_data                   = "${data.template_cloudinit_config.pace-init.rendered}"
  security_groups = ["${aws_security_group.pace-ec2-security-group.id}"]
  key_name = "debug-key"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_cloudinit_config" "pace-init" {
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.launch-configuration-user-data.rendered}"
  }
}

data "template_file" "launch-configuration-user-data" {
  template = "${file("${path.module}/user-data.tpl")}"
  vars {
    docker-compose = "${data.template_file.docker-compose.rendered}"
    pace-config = "${data.template_file.pace-config.rendered}"
  }
}

data "aws_secretsmanager_secret" "superuser_db_password" {
  name = "/pace/superuser_db_password"
}

data "aws_secretsmanager_secret_version" "superuser_db_password" {
  secret_id = "${data.aws_secretsmanager_secret.superuser_db_password.id}"
}

data "template_file" "docker-compose" {
  template = "${file("${path.module}/docker-compose.yml")}"
  vars {
    redis = "${var.redis}"
    postgres = "${var.postgres}"
    db_password = "${data.aws_secretsmanager_secret_version.superuser_db_password.secret_string}"
  }
}

data "template_file" "pace-config" {
  template = "${file("${path.module}/local.json")}"
}
