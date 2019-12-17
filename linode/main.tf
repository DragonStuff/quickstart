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

variable "count_agent_all_nodes" {
  default = "3"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
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

variable "size" {
  default = "g6-standard-1"
}

variable "image" {
  default = "linode/ubuntu18.04"
}

variable "docker_version_server" {
  default = "19.03"
}

variable "docker_version_agent" {
  default = "19.03"
}

variable "ssh_keys" {
  default = []
}

resource "linode_instance" "rancherserver" {
  count     = "1"
  image     = var.image
  label     = "${var.prefix}-rancherserver"
  region    = var.region
  size      = var.size
  user_data = data.template_file.userdata_server.rendered
  ssh_keys  = var.ssh_keys
}

resource "linode_instance" "rancheragent-all" {
  count     = var.count_agent_all_nodes
  image     = var.image
  label     = "${var.prefix}-rancheragent-${count.index}-all"
  region    = var.region
  size      = var.size
  user_data = data.template_file.userdata_agent.rendered
  ssh_keys  = var.ssh_keys
}

resource "linode_instance" "rancheragent-etcd" {
  count     = var.count_agent_etcd_nodes
  image     = var.image
  name      = "${var.prefix}-rancheragent-${count.index}-etcd"
  region    = var.region
  size      = var.size
  user_data = data.template_file.userdata_agent.rendered
  ssh_keys  = var.ssh_keys
}

resource "linode_instance" "rancheragent-controlplane" {
  count     = var.count_agent_controlplane_nodes
  image     = var.image
  name      = "${var.prefix}-rancheragent-${count.index}-controlplane"
  region    = var.region
  size      = var.size
  user_data = data.template_file.userdata_agent.rendered
  ssh_keys  = var.ssh_keys
}

resource "linode_instance" "rancheragent-worker" {
  count     = var.count_agent_worker_nodes
  image     = var.image
  name      = "${var.prefix}-rancheragent-${count.index}-worker"
  region    = var.region
  size      = var.size
  user_data = data.template_file.userdata_agent.rendered
  ssh_keys  = var.ssh_keys
}

data "template_file" "userdata_server" {
  template = file("files/userdata_server")

  vars = {
    admin_password        = var.admin_password
    cluster_name          = var.cluster_name
    docker_version_server = var.docker_version_server
    rancher_version       = var.rancher_version
  }
}

data "template_file" "userdata_agent" {
  template = file("files/userdata_agent")

  vars = {
    admin_password       = var.admin_password
    cluster_name         = var.cluster_name
    docker_version_agent = var.docker_version_agent
    rancher_version      = var.rancher_version
    server_address       = linode_instance.rancherserver[0].ipv4_address
  }
}

output "rancher-url" {
  value = ["https://${linode_instance.rancherserver[0].ipv4_address}"]
}

