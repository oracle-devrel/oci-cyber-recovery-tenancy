instances = {
  instance_1 = {
    availability_domain                        = 2
    compartment_id                             = "Compartment-Name"
    shape                                      = "VM.Standard.E4.Flex"
    display_name                               = "instance_1"
    boot_volume_size_in_gbs                    = null
    fault_domain                               = "FAULT-DOMAIN-2"
    dedicated_vm_host_id                       = null
    source_id                                  = "Image-Name"
    source_type                                = "image"
    network_compartment_id                     = "Network-Compartment"
    vcn_name                                   = "VCN NAme"
    subnet_id                                  = "subnet1"
    assign_public_ip                           = false
    private_ip                                 = "x.x.x.x"
    hostname_label                             = null
    nsg_ids                                    = [""]
    ocpus                                      = "4"
    memory_in_gbs                              = "60"
    capacity_reservation_id                    = null
    create_is_pv_encryption_in_transit_enabled = null
    update_is_pv_encryption_in_transit_enabled = null
    ssh_authorized_keys                        = "ssh_public_key"
    backup_policy                              = ""
    policy_compartment_id                      = ""
    defined_tags                               = {}
    freeform_tags                              = {}
  },
  Instance2-Name = {
    availability_domain                        = 2
    compartment_id                             = "Compartment-Name"
    shape                                      = "VM.Standard.E4.Flex"
    display_name                               = "Instance2-Name"
    boot_volume_size_in_gbs                    = null
    fault_domain                               = "FAULT-DOMAIN-2"
    dedicated_vm_host_id                       = null
    source_id                                  = "Instance2-Name"
    source_type                                = "image"
    network_compartment_id                     = "CRS_APP_RedRoom"
    vcn_name                                   = "vcn-name"
    subnet_id                                  = "subnet-1"
    assign_public_ip                           = false
    private_ip                                 = "x.x.x.x"
    hostname_label                             = null
    nsg_ids                                    = [""]
    ocpus                                      = "4"
    memory_in_gbs                              = "60"
    capacity_reservation_id                    = null
    create_is_pv_encryption_in_transit_enabled = null
    update_is_pv_encryption_in_transit_enabled = null
    ssh_authorized_keys                        = "ssh_public_key"
    backup_policy                              = ""
    policy_compartment_id                      = ""
    defined_tags                               = {}
    freeform_tags                              = {}
  },
  ##Add New Instances for london here##
}


