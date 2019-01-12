resource "aws_network_acl" "pace-vpc-network-acl" {
  vpc_id     = "${aws_vpc.pace-vpc.id}"
  subnet_ids = ["${aws_subnet.pace-ec2-subnet.id}"]

  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "pace-vpc-network-acl"
  }
}
