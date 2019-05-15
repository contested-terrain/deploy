output "instance_public_ip" {
  value = "${digitalocean_droplet.wp.ipv4_address}"
}
