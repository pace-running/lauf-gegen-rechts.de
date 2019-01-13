resource "aws_route53_zone" "lauf-gegen-rechts" {
  name = "lauf-gegen-rechts.de"
}

resource "aws_route53_record" "www" {
  zone_id = "${aws_route53_zone.lauf-gegen-rechts.id}"
  name    = "www.${aws_route53_zone.lauf-gegen-rechts.name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["213.128.138.130"]
  //records = ["${var.load-balancer-name}"]
}

resource "aws_route53_record" "MX" {
  name = "${aws_route53_zone.lauf-gegen-rechts.name}"
  type = "MX"
  zone_id = "${aws_route53_zone.lauf-gegen-rechts.id}"
  records = ["10 mail.kluenter.de"]
  ttl = "3600"
}
