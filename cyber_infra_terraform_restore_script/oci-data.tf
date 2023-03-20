############################
# Resource Block - Identity
# Fetch Compartments
############################

#Fetch Compartment Details
data "oci_identity_compartments" "compartments" {
  #Required
  compartment_id = var.tenancy_ocid

  #Optional
  #name = var.compartment_name
  access_level              = "ANY"
  compartment_id_in_subtree = true
  state                     = "ACTIVE"
}


############################
# Data Block - Network
# Fetch ADs
############################

data "oci_identity_availability_domains" "availability_domains" {
  #Required
  compartment_id = var.tenancy_ocid
}


############################
# Data Block 
# Fetch Custom Images
############################


data "oci_core_images" "custom_images" {
  #Required
  compartment_id = var.compartment_ocids["Compartment-Name"]



}

############################
# Data Block 
# Fetch Mount Targets
############################

data "oci_file_storage_mount_targets" "mount_targets" {
  #Required
  availability_domain = data.oci_identity_availability_domains.availability_domains.availability_domains["2"].name
  compartment_id      = var.compartment_ocids["Compartment-Name"]


}


############################
# Data Block
# Fetch Cap_reservation
############################


data "oci_core_compute_capacity_reservations" "compute_capacity_reservations" {
  #Required
  compartment_id = var.compartment_ocids["Compartment-Name"]

}

