provider "oci" {
  region = var.region
}

resource "oci_core_vcn" "my_vcn" {
  cidr_block     = var.vcn_cidr
  display_name   = var.vcn_name
  compartment_id = var.compartment_id
}
