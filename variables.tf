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

variable "version" {
  description = "Determines which image version will be deployed."
  type        = string
  default     = "20.3.1" #Make sure the version is available in the Marketplace
}

variable "image_type" {
  description = "Determines whether CSR SDWAN ("csr") or vEdge ("vedge", default) image should be used."
  type        = string
  default     = "vedge" #Use "csr" to select CSR image.
}

variable "instance_size" {
  description = "AWS Instance size for the SDWAN gateways"
  type        = string
  default     = "t2.small"
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