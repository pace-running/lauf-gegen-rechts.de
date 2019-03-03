resource "aws_autoscaling_group" "ecs-autoscaling-group" {
  name                 = "${var.app_name}-as"
  max_size             = "4"
  min_size             = "2"
  desired_capacity     = "2"
  vpc_zone_identifier  = ["${var.subnet_ids}"]
  launch_configuration = "${aws_launch_configuration.pace-launch-configuration.name}"
  health_check_type    = "ELB"

  lifecycle {
    create_before_destroy = true
  }
}
