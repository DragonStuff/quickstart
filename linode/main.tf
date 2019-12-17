# Configure the Linode Provider
provider "linode" {
  token = var.linode_token
}

variable "linode_token" {
  default = "$LINODE_TOKEN"
}

variable "prefix" {
  default = "yourname"
}

variable "rancher_version" {
  default = "latest"
}

variable "admin_password" {
  default = "admin"
}

variable "cluster_name" {
  default = "quickstart"
}

variable "region" {
  default = "ap-southeast"
}

variable "type" {
  default = "g6-standard-1"
}

variable "image" {
  default = "linode/ubuntu18.04"
}

variable "group" {
  default = "rancher"
}

variable "tags" {
  default = []
}

variable "docker_version_server" {
  default = "19.03"
}

variable "ssh_keys" {
  default = []
}

resource "linode_stackscript" "rancher_server_userdata" {
  label = "rancher_server_userdata"
  description = "Installs Rancher Server"
  script = file("files/userdata_server")
  image = var.image
  rev_note = "ALPHA - NO PROD"
}

resource "linode_instance" "rancherserver" {
  image          = var.image
  label          = "${var.prefix}-rancherserver"
  region         = var.region
  type           = var.type
  stackscript_id = "${linode_stackscript.rancher_server_userdata.id}"
  stackscript_data = {
    admin_password        = var.admin_password
    cluster_name          = var.cluster_name
    docker_version_server = var.docker_version_server
    rancher_version       = var.rancher_version
  }
  ssh_keys       = var.ssh_keys
  group          = var.group
  tags           = var.tags
}

output "rancher-url" {
  value = ["https://${linode_instance.rancherserver[0].ipv4_address}"]
}

