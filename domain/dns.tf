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

resource "aws_route53_record" "mail" {
  name = "mail.${aws_route53_zone.lauf-gegen-rechts.name}"
  type = "A"
  records = ["213.128.138.199"]
  zone_id = "${aws_route53_zone.lauf-gegen-rechts.id}"
  ttl = "3600"
}

resource "aws_route53_record" "MX" {
  name = "${aws_route53_zone.lauf-gegen-rechts.name}"
  type = "MX"
  zone_id = "${aws_route53_zone.lauf-gegen-rechts.id}"
  records = ["10 mail.${aws_route53_zone.lauf-gegen-rechts.name}"]
  ttl = "3600"
}
