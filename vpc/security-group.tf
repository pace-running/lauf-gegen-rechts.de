resource "aws_security_group" "pace-vpc-security-group" {
  name = "pace-vpc-security-group"
  vpc_id = "${aws_vpc.pace-vpc.id}"

  // HTTPS
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  // HTTP
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

output "security-group-id" {
  value = "${aws_security_group.pace-vpc-security-group.id}"
}
