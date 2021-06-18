variable "name" {
  description = "Custom name for VPC and sdwan headends"
  type        = string
  default     = ""
}

variable "region" {
  description = "The AWS region to deploy this module in"
  type        = string
}

variable "cidr" {
  description = "The CIDR range to be used for the VPC"
  type        = string
  default     = ""
}

variable "transit_gw_obj" {
  description = "Transit gateway object including attributes, to attach sdwan GW to"
}

variable "az1" {
  description = "Availability zone 1, for headend deployment"
  type        = string
  default     = "a"
}

variable "az2" {
  description = "Availability zone 2, for headend deployment"
  type        = string
  default     = "b"
}

variable "ha_gw" {
  description = "Boolean to determine if module will be deployed in HA or single mode"
  type        = bool
  default     = true
}

variable "vedge_image_version" {
  description = "Determines which image version will be deployed."
  type        = string
  default     = "20.3.1" #Make sure the version is available in the Marketplace
}

variable "csr_image_version" {
  description = "Determines which image version will be deployed."
  type        = string
  default     = "17.3.1a" #Make sure the version is available in the Marketplace
}

variable "image_type" {
  description = "Determines whether CSR SDWAN (\"csr\") or vEdge (\"vedge\", default) image should be used."
  type        = string
  default     = "vedge" #Use "csr" to select CSR image.
}

variable "instance_size" {
  description = "AWS Instance size for the SDWAN gateways"
  type        = string
  default     = "t2.medium"
}

variable "tunnel_cidr" {
  description = "CIDR to be used to create tunnel addresses"
  type        = string
  default     = "172.31.255.0/28"
}

variable "aviatrix_asn" {
  description = "ASN To be used on Aviatrix Transit Gateway for BGP"
  type        = string
  default     = "65000"
}

variable "sdwan_asn" {
  description = "ASN To be used on SDWAN Gateway for BGP"
  type        = string
  default     = "65001"
}

variable "aviatrix_tunnel_creation" {
  description = "When set to true, the IPSEC tunnels will be provisioned to the Aviatrix transit gateway."
  type        = bool
  default     = false
}

variable "use_existing_vpc" {
  description = "Set to true to use existing VPC."
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "VPC ID, for using an existing VPC."
  type        = string
  default     = ""
}

variable "sdwan_gw_subnet_cidr" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true"
  type        = string
  default     = ""
}

variable "sdwan_ha_subnet_cidr" {
  description = "Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is true and ha_gw is true"
  type        = string
  default     = ""
}

variable "sdwan_gw_subnet_id" {
  description = "Subnet ID, for using an existing VPC. Required when use_existing_vpc is true"
  type        = string
  default     = ""
}

variable "sdwan_ha_subnet_id" {
  description = "Subnet ID, for using an existing VPC. Required when use_existing_vpc is true and ha_gw is true"
  type        = string
  default     = ""
}

variable "second_interface" {
  description = "The additional interface on the SDWAN headend"
  type        = bool
  default     = false

}
locals {
  sdwan_gw_subnet_id   = var.use_existing_vpc ? var.sdwan_gw_subnet_id : aws_subnet.sdwan_1.id
  sdwan_ha_subnet_id   = var.use_existing_vpc ? var.sdwan_ha_subnet_id : aws_subnet.sdwan_2.id
  sdwan_gw_subnet_cidr = var.use_existing_vpc ? var.sdwan_gw_subnet_cidr : aws_subnet.sdwan_1.cidr_block
  sdwan_ha_subnet_cidr = var.use_existing_vpc ? var.sdwan_ha_subnet_cidr : aws_subnet.sdwan_2.cidr_block
  ami                  = length(regexall("vedge", lower(var.image_type))) > 0 ? data.aws_ami.vedge.id : data.aws_ami.csr.id
}
