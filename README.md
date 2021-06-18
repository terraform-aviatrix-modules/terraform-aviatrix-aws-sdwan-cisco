# terraform-aviatrix-aws-sdwan-cisco

### Description
Deploys edge VPC with SDWAN headends and creates tunnels on the Aviatrix transit gateway. Tunnels on the Cisco headends need to be created manually.

### Diagram
\<Provide a diagram of the high level constructs thet will be created by this module>
<img src="<IMG URL>"  height="250">

### Compatibility
Module version | Terraform version | Controller version | Terraform provider version
:--- | :--- | :--- | :---
v1.0.0 | | |

### Usage Example new VPC
```
module "sdwan_edge" {
  source  = "terraform-aviatrix-modules/aws-sdwan-viptela/aviatrix"
  version = "1.0.0"

  cidr = "10.1.0.0/20"
  region = "eu-west-1"
  transit_gw_obj = "transit_1"
}
```

### Usage Example deploy in Aviatrix transit VPC
```
module "transit_aws" {
  source  = "terraform-aviatrix-modules/aws-transit/aviatrix"
  version = "v4.0.1"

  cidr    = "10.1.0.0/20"
  region  = var.aws_region
  account = aviatrix_account.aws.account_name
}

module "sdwan" {
  source = "git::https://github.com/terraform-aviatrix-modules/terraform-aviatrix-aws-sdwan-cisco"

  region               = var.aws_region
  transit_gw_obj       = module.transit_aws.transit_gateway
  image_type           = "csr"
  second_interface     = true
  use_existing_vpc     = true
  vpc_id               = module.transit_aws.vpc.vpc_id
  sdwan_gw_subnet_cidr = module.transit_aws.vpc.public_subnets[0].cidr
  sdwan_gw_subnet_id   = module.transit_aws.vpc.public_subnets[0].subnet_id
  sdwan_ha_subnet_cidr = module.transit_aws.vpc.public_subnets[2].cidr
  sdwan_ha_subnet_id   = module.transit_aws.vpc.public_subnets[2].subnet_id
}
```



### Variables
The following variables are required:

key | value
:--- | :---
cidr | 	The IP CIDR to be used to create the SDWAN VPC. (not required when use_existing_vpc is enabled)
region | AWS region to deploy the SDWAN VPC in
transit_gw_obj | The transit gateway object (including all attributes) we want to attach this SDWAN edge to.

The following variables are optional:

key | default | value 
:---|:---|:---
name | avx-\<region\>-sdwan-edge | When name is provided, avx-\<name\>-edge will be used.
az1 | "a" | Availability zone 1, for headend deployment.
az2 | "b" | Availability zone 2, for headend deployment.
ha_gw | true | Set to false te deploy a single sdwan headend. Make sure this matches the transit GW. They have to be both HA or both Single. Mix is not supported.
instance_size | t2.small | Instance size of the SDWAN GW's
vedge_image_version | 20.3.1 | Provide version number to deploy headends with. Set to empty to use latest.
csr_image_version | 17.3.1 | Provide version number to deploy headends with. Set to empty to use latest.
image_type | vedge | "Determines whether CSR SDWAN ("csr") or vEdge ("vedge") image should be used."
tunnel_cidr | 172.31.255.0/28 | CIDR for creation of tunnel IP's. At least /28 is required, even in non-HA. This is because the module will always carve out 4x /30.
aviatrix_asn | 65000 | ASN To be used on Aviatrix Transit Gateway for BGP
sdwan_asn | 65001 | ASN To be used on SDWAN Gateway for BGP
aviatrix_tunnel_creation | true | When set to false, the IPSEC tunnels will not be provisioned to the Aviatrix transit gateway.
use_existing_vpc | false | Set to true to use an existing VPC in stead of having this module create one.
vpc_id | | VPC ID, for using an existing VPC.
sdwan_gw_subnet_cidr | | Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is enabled. Make sure this is a public subnet.
sdwan_ha_subnet_cidr | | Subnet CIDR, for using an existing VPC. Required when use_existing_vpc is enabled and ha_gw is true. Make sure this is a public subnet.
sdwan_gw_subnet_id | | Subnet ID, for using an existing VPC. Required when use_existing_vpc is enabled. Make sure this is a public subnet.
sdwan_ha_subnet_id | | Subnet ID, for using an existing VPC. Required when use_existing_vpc is enabled and ha_gw is true. Make sure this is a public subnet.
second_interface | false | Add second interface to the SDWAN headend. Will be created in the same subnet as the first interface. VPN tunnel created will be done against the second interface if enabled.

### Outputs
This module will return the following outputs:

key | description
:---|:---
\<keyname> | \<description of object that will be returned in this output>
