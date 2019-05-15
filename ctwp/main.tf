variable "do_token" {
  description = "Your Digital Ocean API token"
}

variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication"
}

variable "private_key_path" {
  description = "Path to the SSH private key"
}

variable "do_key_name" {
  description = "Name of the key on Digital Ocean"
  default = "ct"
}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_ssh_key" "ct_key" {
  name = "${var.do_key_name}"
  public_key = "${file(var.public_key_path)}"
}

module "ctwp-old" {
  source           = "./modules/wp"
  name             = "ctwp-old"
  ssh_key_id       = "${digitalocean_ssh_key.ct_key.id}"
  private_key_path = "${var.private_key_path}"
  wp_db_path       = "./ctwp-2019-03-24-ac9f685.sql"
}

output "ctwp-old" {
  value = "${module.ctwp-old.instance_public_ip}"
}

module "ctwp-v2" {
  source           = "./modules/wp"
  name             = "ctwp-v2"
  ssh_key_id       = "${digitalocean_ssh_key.ct_key.id}"
  private_key_path = "${var.private_key_path}"
}

output "ctwp-v2.public_ip" {
  value = "${module.ctwp-v2.instance_public_ip}"
}
