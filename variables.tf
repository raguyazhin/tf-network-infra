variable "region" {
  description = "OCI region"
  type        = string
}

variable "vcn_cidr" {
  description = "CIDR block for VCN"
  type        = string
}

variable "vcn_name" {
  description = "Name for VCN"
  type        = string
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
}
