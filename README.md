# Rancher and LKS (Terraform)

## Summary

**NOTE:** Terraform 0.12.0 or higher is required for cloud based environments. (Linode, AWS and DigitalOcean)

This repo contains scripts that will allow you to quickly deploy and test Rancher for POC.
The contents aren't intended for production but are here to get you up and going with running Rancher Server for a POC and to help show the functionality.

## Linode quick start

**NOTE:** Terraform 0.12.0 or higher is required.

The Linode folder contains terraform code to stand up a single Rancher server instance with NO cluster attached to it.
This is intended for use with LKS (Linode Kubernetes Service)

You can import an existing cluster (run the kubectl commands to link your new Rancher server to your LKS cluster) once you log into Rancher.

This terraform setup will:

- Start a new Linode running `rancher/rancher` version specified in `rancher_version`

### How to use

- Clone this repository and go into the **Linode** subfolder
- Move the file `terraform.tfvars.example` to `terraform.tfvars` and edit (see inline explanation)
- Run `terraform init`
- Run `terraform apply`

When provisioning has finished you will be given the url to connect to the Rancher Server

### How to Remove

To remove the VM's that have been deployed run `terraform destroy --force`

**Please be aware that you will be responsible for the usage charges with Linode**
