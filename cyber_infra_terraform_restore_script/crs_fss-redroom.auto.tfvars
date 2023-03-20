fss_blueroom = {
  PRD_IAO11P_122_APPS-3 = {
    availability_domain = "2"
    compartment_id      = "Compartment-Name"
    #Optional
    display_name         = "PRD_IAO11P_122_APPS-3"
    kms_key_name         = ""
    source_snapshot_name = ""
    defined_tags         = {}
    freeform_tags        = {}
  },
  PRD_IAO11P_122_APPS-2 = {
    availability_domain = "2"
    compartment_id      = "Compartment-Name"
    #Optional
    display_name         = "PRD_IAO11P_122_APPS-2"
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
  FSE-PRD_AMBER_MT-PRD_IAO11P_122_APPS-3-export-IAO11P-APPS_122-3 = {
    export_set_id  = "PRD_AMBER_MT"
    file_system_id = "PRD_IAO11P_122_APPS-3"
    path           = "/export/IAO11P-APPS_122-3"
    export_options = [{
      #Required
      source = "10.166.125.34/31"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
      }, {
      #Required
      source = "10.129.218.0/28"
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
  FSE-PRD_AMBER_MT-PRD_IAO11P_122_APPS-2-export-IAO11P-APPS_122-2 = {
    export_set_id  = "PRD_AMBER_MT"
    file_system_id = "PRD_IAO11P_122_APPS-2"
    path           = "/export/IAO11P-APPS_122-2"
    export_options = [{
      #Required
      source = "10.166.125.34/31"
      #Optional
      access                         = "READ_WRITE"
      anonymous_gid                  = "65534"
      anonymous_uid                  = "65534"
      identity_squash                = "NONE"
      require_privileged_source_port = "false"
      }, {
      #Required
      source = "10.129.218.0/28"
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
