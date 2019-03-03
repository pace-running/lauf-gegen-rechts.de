resource "aws_elasticache_cluster" "pace-redis" {
  cluster_id           = "${var.app_name}-pace-redis"
  engine               = "redis"
  engine_version       = "4.0.10"
  node_type            = "cache.t2.small"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis4.0"
  subnet_group_name    = "${aws_elasticache_subnet_group.redis-subnet.name}"
  security_group_ids   = ["${aws_security_group.redis-security-group.id}"]
  port                 = 6379
}

resource "aws_security_group" "redis-security-group" {
  name   = "${var.app_name}-redis-security-group"
  vpc_id = "${var.vpc-id}"

  ingress {
    from_port       = 6379
    protocol        = "tcp"
    to_port         = 6379
    security_groups = ["${var.security-group-id}"]
  }
}

resource "aws_elasticache_subnet_group" "redis-subnet" {
  name       = "${var.app_name}-redis-subnet"
  subnet_ids = ["${var.redis-subnet-id}"]
}

output "redis-ip" {
  value = "${aws_elasticache_cluster.pace-redis.cache_nodes.0.address}"
}

output "redis-security-group-id" {
  value = "${aws_security_group.redis-security-group.id}"
}
