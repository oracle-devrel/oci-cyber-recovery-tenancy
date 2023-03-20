#------------Delay----------------#

#The Time sleep resource is to delay the bv attachemnt once the instance creation is over

resource "time_sleep" "wait_40_seconds" {

  depends_on = [module.instances]

  create_duration = "120s"
}


locals {
  image_availability = zipmap(data.oci_core_images.custom_images.images[*].display_name, data.oci_core_images.custom_images.images[*].id)
}

#---------Instance name---------#
resource "oci_core_volume_attachment" "instance_name_attachment1" {
  count           = lookup(local.image_availability, "instance_name", null) != null ? 1 : 0
  depends_on      = [time_sleep.wait_40_seconds]
  attachment_type = "paravirtualized"
  instance_id     = merge(module.instances.*...)["instance_name"]["instance_tf_id"]
  volume_id       = module.block-volumes["instance_name-block_volume_name"].block_volume_tf_id
}
