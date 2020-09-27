data "aws_ami" "vedge" {
  most_recent = true
  filter {
    name   = "name"
    values = ["*${var.vedge_image_version}*vEdge-Marketplace*"]
  }
  owners = ["679593333241"] # Marketplace
}

data "aws_ami" "csr" {
  most_recent = true
  filter {
    name   = "name"
    values = ["Cisco-CSR-SDWAN*${var.csr_image_version}*"]
  }
  owners = ["679593333241"] # Marketplace
}