fss_blueroom = {
  fss1 = {
    availability_domain = "2"
    compartment_id      = "Compartment-Name"
    #Optional
    display_name         = "fss1"
    kms_key_name         = ""
    source_snapshot_name = ""
    defined_tags         = {}
    freeform_tags        = {}
  },
  fss2 = {
    availability_domain = "2"
    compartment_id      = "Compartment-Name"
    #Optional
    display_name         = "fss2"
    kms_key_name         = ""
    source_snapshot_name = ""
    defined_tags         = {}
    freeform_tags        = {}
  },
}
// Copyright (c) 2021, 2022, Oracle and/or its affiliates.
############################
# Storage
# Export Options - tfvars
# Allowed Values:
# compartment_id and policy_compartment_id can be the ocid or the name of the compartment hierarchy delimited by double hiphens "--"
# Example : compartment_id = "ocid1.compartment.oc1..aaaaaaaahwwiefb56epvdlzfic6ah6jy3xf3c" or compartment_id = "Network-root-cpt--Network" where "Network-root-cpt" is the parent of "Network" compartment
############################
nfs_export_options_blueroom = {
  fss1_export_1 = {
    export_set_id  = "crs_fss_export"
    file_system_id = "fss1"
    path           = "/export/fss1"
    export_options = [{
      #Required
      source = "x.x.x.x/31"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
      }, {
      #Required
      source = "x.x.x.x/28"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
    }]
    defined_tags  = {}
    freeform_tags = {}
  },
  fss2_export_2 = {
    export_set_id  = "crs_fss_export"
    file_system_id = "fss2"
    path           = "/export/fss2"
    export_options = [{
      #Required
      source = "x.x.x.x/31"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
      }, {
      #Required
      source = "x.x.x.x/28"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
    }]
    defined_tags  = {}
    freeform_tags = {}
  },
}
