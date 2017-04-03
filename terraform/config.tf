provider "aws" {
  access_key = "${var.xtl_access_key}"
  secret_key = "${var.xtl_secret_key}"
  region     = "${var.xtl_region}"
}
