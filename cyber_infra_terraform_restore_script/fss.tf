module "fss" {
  #depends_on = [module.mts_blueroom]
  #Required
  source   = "./modules/storage/file-storage/fss"
  for_each = (var.fss_blueroom != null || var.fss_blueroom != {}) ? var.fss_blueroom : {}

  #Required
  availability_domain = each.value.availability_domain != "" && each.value.availability_domain != null ? data.oci_identity_availability_domains.availability_domains.availability_domains[each.value.availability_domain].name : ""
  compartment_id      = each.value.compartment_id != null ? (length(regexall("ocid1.compartment.oc1*", each.value.compartment_id)) > 0 ? each.value.compartment_id : var.compartment_ocids[each.value.compartment_id]) : null

  #Optional
  defined_tags       = each.value.defined_tags
  display_name       = each.value.display_name != null ? each.value.display_name : null
  freeform_tags      = each.value.freeform_tags
  kms_key_id         = each.value.kms_key_name
  source_snapshot_id = each.value.source_snapshot_name
}

module "fss-export-options" {
  #Required
  source   = "./modules/storage/file-storage/export-option"
  for_each = (var.nfs_export_options_blueroom != null || var.nfs_export_options_blueroom != {}) ? var.nfs_export_options_blueroom : {}

  #Required
  #  export_set_id      = length(regexall("ocid1.mounttarget.oc1*", each.value.export_set_id)) > 0 ? each.value.export_set_id : merge(module.mts_blueroom.*...)[each.value.export_set_id]["mt_exp_set_id"]
  export_set_id      = lookup(zipmap(data.oci_file_storage_mount_targets.mount_targets.mount_targets[*].display_name, data.oci_file_storage_mount_targets.mount_targets.mount_targets[*].export_set_id), each.value.export_set_id)
  file_system_id     = length(regexall("ocid1.filesystem.oc1*", each.value.file_system_id)) > 0 ? each.value.file_system_id : merge(module.fss.*...)[each.value.file_system_id]["fss_tf_id"]
  export_path        = each.value.path
  nfs_export_options = var.nfs_export_options_blueroom
  key_name           = each.key
}
