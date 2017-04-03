resource "aws_instance" "drupalcivicrm" {
  ami = "${var.xtl_aws_ami}"

  instance_type = "t2.micro"

  security_groups = [
    "${aws_security_group.drupalcivicrm_security_group.name}",
  ]

  availability_zone = "${var.xtl_zone}"

  key_name = "${aws_key_pair.auth.id}"

  # add a public IP address
  associate_public_ip_address = true

  root_block_device = {
    "volume_type"           = "standard"
    "volume_size"           = 8
    "delete_on_termination" = true
  }

  tags {
    Name = "DrupalCiviCRM Server"
  }
}

resource "aws_eip" "drupalcivicrm_eip" {
  instance = "${aws_instance.drupalcivicrm.id}"
}

resource "aws_route53_record" "drupalcivicrm" {
  zone_id = "${var.xtl_route53_hosted_zone_id}"
  name    = "drupalcivicrm.${var.xtl_route53_domain_name}"
  type    = "A"
  ttl     = "3600"
  records = ["${aws_eip.drupalcivicrm_eip.public_ip}"]
}
