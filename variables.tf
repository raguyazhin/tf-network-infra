variable "region" {
  description = "OCI region"
  type        = string
  default = "us-ashburn-1"
}



variable "vcn_cidr" {
  description = "CIDR block for VCN"
  type        = string
  default = "10.10.0.0/16"
}

variable "vcn_name" {
  description = "Name for VCN"
  type        = string
  default = "prod-virtual-cloud-network"
}

variable "compartment_id" {
  description = "OCI Compartment ID"
  type        = string
  default = "ocid1.compartment.oc1..your_actual_compartment_id"
}
