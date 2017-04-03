output "DrupalCiviCRM_Public_IP" {
  value = "${aws_eip.drupalcivicrm_eip.public_ip}"
}

output "DrupalCiviCRM_DNS" {
  value = "${aws_instance.drupalcivicrm.public_dns}"
}
