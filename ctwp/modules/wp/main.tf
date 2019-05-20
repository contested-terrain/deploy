resource "random_string" "wp_db_password" {
  length = 12
  special = false
}

resource "digitalocean_droplet" "wp" {
  name     = "${var.name}"
  image    = "docker-18-04"
  region   = "nyc3"
  size     = "512mb"
  ssh_keys = ["${var.ssh_key_id}"]
  private_networking = true

  connection {
    type = "ssh"
    user = "root"
    agent = true
    private_key = "${file("${var.private_key_path}")}"
  }

  provisioner "file" {
    source = "${var.docker_config}"
    destination = "./stack.yml"
  }

  provisioner "remote-exec" {
    inline = ["mkdir -p ./wp-files"]
  }

  provisioner "file" {
    source = "${var.wp_files}" # path must include trailing /
    destination = "./wp-files"
  }

  provisioner "file" {
    source = "./scripts/wp-cli.sh"
    destination = "./wp-cli.sh"
  }

  provisioner "file" {
    source = "./scripts/import-wpdb.sh"
    destination = "./import-wpdb.sh"
  }

  provisioner "file" {
    source = "${var.wp_db_path}"
    destination = "ctwp.sql"
    on_failure = "continue"
  }

  # Setup docker swarm, set secret, and deploy stack
  provisioner "remote-exec" {
    inline = [
      "echo \"Deploying stack...\"",
      "docker swarm init --advertise-addr ${digitalocean_droplet.wp.ipv4_address_private}",
      "echo ${random_string.wp_db_password.result} | docker secret create ctwp_db_password -",
      "docker stack up -c stack.yml ctwp",
    ]
  }

  # Configure WP
  provisioner "remote-exec" {
    inline = [
      "chmod u+x ./wp-cli.sh; chmod u+x ./import-wpdb.sh",
      "echo \"Sleeping for 40 seconds while services can spin up...\"; sleep 40",
      "echo \"Importing DB into Wordpress...\"",
      "./wp-cli.sh core install --url=\"http://temp\"  --title=Temp --admin_user=admin --admin_email=admin@example.com",
      "mkdir data && mv ctwp.sql data && ./import-wpdb.sh ctwp.sql",
      "./wp-cli.sh option update home \"http://${digitalocean_droplet.wp.ipv4_address}:8080\"",
      "./wp-cli.sh option update siteurl \"http://${digitalocean_droplet.wp.ipv4_address}:8080\"",
    ]
  }
}
