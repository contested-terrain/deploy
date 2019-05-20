variable "name" {
  description = "The resource name for each instance of this module"
}

variable "ssh_key_id" {
  description = "The id of the ssh_key to be used for this modules resources"
}

variable "private_key_path" {}

variable "wp_db_path" {
  description = "Path to the DB to load into the WP instance."
  default = ""
}

variable "wp_files" {
  description = "Path to wordpress files for instance, if any"
  default = ""
}

variable "docker_config" {
  description = "Path to the YML config file for the docker stack"
  default = "./docker/full-stack.yml"
}
