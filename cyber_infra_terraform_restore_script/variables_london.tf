// Copyright (c) 2021, 2022, Oracle and/or its affiliates.

############################
#
# Variables Block
# OCI
#
############################

variable "tenancy_ocid" {
  type    = string
  default = "ocid1.tenancy.oc1..aaaaaaaauajecrvwpzhrf22tvyw7pc5potge3k3a7nq4623nw4gdytj777ga"
}

variable "user_ocid" {
  type    = string
  default = ""
}

variable "fingerprint" {
  type    = string
  default = ""
}

variable "private_key_path" {
  type    = string
  default = ""
}

variable "region" {
  type    = string
  default = "uk-london-1"
}

#################################
# SSH Keys
#################################

variable "instance_ssh_keys" {
  type = map(any)
  default = {
    ssh_public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADEwIdcYiZOUhVugTdDRn9DM6yg3vKS/G4wxBMALnBavGnl/0OVWT53tN8q8O9X6T1QaxOvEG/fySv6w0vgWfpSNIMCz2/HHHpYYmDCZ8kWN3v1VPTjOqtIAnl3zc8pUlVY9pTFB4jG9lNgJwYPvKIcVr/6IiQTVqs3AtnU3jP+++s0jeXzjinXkvl79KGsrLP3IbC+vfj846Muq97207qttlQVpo6+roiSncOq+nEpl3LxIPzTFL0L/hY7NuAePJi6q5DuPR+7Fjvd8bC0QU3 AVIVA_Cyber_recovery_SSH_key \nssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC3WZkS05tAmxYN4gdo11lBWjQ+8bV25GDVOEx/WLx7SkmZLOkTqM+xQkTZDDiOeOQVLHJX7ElQA7a65DGQxmrFtDrFiEGRQBzItSoWoCOg0Ie7AxNkOxtIVjX6mcZ+YAjQp4XkmnL0r6ShIoIy+BUk6xXYJ0UVaf3uxgUm9lMcZ/3mHreoHGBwSxPQOFsoozPoZS5i+Q4L3upb2qXiJ+QlYR7qGgysAjbrlhZ2hZT7jNS6klwoiRseRK7mv/ZTGr+3++FuxgXSyrqiQqJr0uWP6VtwPo/oH7M3B3MDo0KMtE5U9bjSJqx0x0qkPXNvBger1cv9QgMj3aK/id0N9ScAUCRQaXM0pX8ZTT2irS07x+zol+5SAr+QPbj1Pd/NwpEU5lajBrz8AoWuedXA65oomOaCaeXVrmVu2JhPKQXB24nHKp+5JEZbn2DVN6VlmXSPIh/gYgxVL1M072AfB1pz3dFwm+o7867D+nR9/F91eJG3sDX4WinCqxpto/21Z9k= vallan2@ukl3lfiebsl017"
    #START_instance_ssh_keys#
    # exported instance ssh keys
    #instance_ssh_keys_END#
  }
}

variable "exacs_ssh_keys" {
  type = map(any)
  default = {
    ssh_public_key = ["ssh-rsa AAAAB3NzaC1ycE39IdcYiZOUhVugTdDRn9DM6yg3vKS/G4wxBMALnBavGnl/0OVWT53tN8q8O9X6T1QaxOvEG/fySv6w0vgWfpSNIMCz2/HHHpYYmDCZ8kWN3v1VPTjOqtIAnl3zc8pUlVY9pTFB4jG9lNgJwYPvKIcVr/6IiQTVqs3AtnU3jP+++s0jeXzjinXkvl79KGsrLP3IbC+vfj846Muq97207qttlQVpo6+roiSncOq+nEpl3LxIPzTFL0L/hY7NuAePJi6q5DuPR+7Fjvd8bC0QU3 AVIVA_Cyber_recovery_SSH_key"]
    #START_exacs_ssh_keys#
    # exported exacs ssh keys
    #exacs_ssh_keys_END#
  }
}

variable "dbsystem_ssh_keys" {
  type = map(any)
  default = {
    ssh_public_key = "ssh-rsa AAAAB339xsrRE5vG6OYM7E1zNYjNA5kozszZ3bMGcMRZH3fiwIdcYiZOUhVugTdDRn9DM6yg3vKS/G4wxBMALnBavGnl/0OVWT53tN8q8O9X6T1QaxOvEG/fySv6w0vgWfpSNIMCz2/HHHpYYmDCZ8kWN3v1VPTjOqtIAnl3zc8pUlVY9pTFB4jG9lNgJwYPvKIcVr/6IiQTVqs3AtnU3jP+++s0jeXzjinXkvl79KGsrLP3IbC+vfj846Muq97207qttlQVpo6+roiSncOq+nEpl3LxIPzTFL0L/hY7NuAePJi6q5DuPR+7Fjvd8bC0QU3 AVIVA_Cyber_recovery_SSH_key"

    #START_dbsystem_ssh_keys#
    # exported dbsystem ssh keys
    #dbsystem_ssh_keys_END#
  }
}

#################################
# Platform Image OCIDs and
# Market Place Images
#################################

variable "instance_source_ocids" {
  type = map(any)
  default = {
    Linux    = "ocid1.image.oc1.uk-london-1.aaaaaaaaf5niayyw6ldf5hec4hspbfarsh4hl7d6ylzwxv2aijdxajq6xfpa"
    Windows  = "ocid1.image.oc1.uk-london-1.aaaaaaaaswwndll4xfrpsm5u4byxysj26zif5orefaadpkp4w4aaxiufp7uq"
    PaloAlto = "Palo Alto Networks VM-Series Next Generation Firewall"
    #START_instance_source_ocids#
    # exported instance image ocids
    #instance_source_ocids_END#
  }
}


#################################
#
# Variables according to Services
# PLEASE DO NOT MODIFY
#
#################################

##########################
## Fetch Compartments ####
##########################

variable "compartment_ocids" {
  type = map(any)
  default = {
    #START_compartment_ocids#
    #compartment_ocids_END#
  }
}


#########################
## Instances/Block Volumes ##
#########################

variable "blockvolumes" {
  type        = map(any)
  description = "To provision block volumes"
  default     = {}
}

variable "block_backup_policies" {
  type        = map(any)
  description = "To create block volume back policy"
  default     = {}
}

variable "instances" {
  type        = map(any)
  description = "Map of instances to be provisioned"
  default     = {}
}

variable "boot_backup_policies" {
  type        = map(any)
  description = "Map of boot volume backup policies to be provisioned"
  default     = {}
}

#########################
######### FSS ###########
#########################

variable "mount_targets" {
  description = "To provision Mount Targets"
  type        = map(any)
  default     = {}
}

variable "fss" {
  description = "To provision File System Services"
  type        = map(any)
  default     = {}
}

variable "nfs_export_options" {
  description = "To provision Export Sets"
  type        = map(any)
  default     = {}
}
##############
variable "mount_targets_blueroom" {
  description = "To provision Mount Targets"
  type        = map(any)
  default     = {}
}

variable "fss_blueroom" {
  description = "To provision File System Services"
  type        = map(any)
  default     = {}
}

variable "nfs_export_options_blueroom" {
  description = "To provision Export Sets"
  type        = map(any)
  default     = {}
}
#############
variable "mount_targets_redroom" {
  description = "To provision Mount Targets"
  type        = map(any)
  default     = {}
}

variable "fss_redroom" {
  description = "To provision File System Services"
  type        = map(any)
  default     = {}
}

variable "nfs_export_options_redroom" {
  description = "To provision Export Sets"
  type        = map(any)
  default     = {}
}



##########################
# Add new variables here #
##########################

variable "capacity_reservation_ocids" {
  type = map(any)
  default = {
    "AD1" : "<AD1 Capacity Reservation OCID>",
    "AD2" : "<AD2 Capacity Reservation OCID>",
    "AD3" : "<AD3 Capacity Reservation OCID>"
  }
}



#########################
#### Load Balancers #####
#########################

variable "load_balancers" {
  description = "To provision Load Balancers"
  type        = map(any)
  default     = {}
}

variable "hostnames" {
  description = "To provision Load Balancer Hostnames"
  type        = map(any)
  default     = {}
}

variable "certificates" {
  description = "To provision Load Balancer Certificates"
  type        = map(any)
  default     = {}
}

variable "cipher_suites" {
  description = "To provision Load Balancer Cipher Suites"
  type        = map(any)
  default     = {}
}

variable "backend_sets" {
  description = "To provision Load Balancer Backend Sets"
  type        = map(any)
  default     = {}
}

variable "backends" {
  description = "To provision Load Balancer Backends"
  type        = map(any)
  default     = {}
}

variable "listeners" {
  description = "To provision Load Balancer Listeners"
  type        = map(any)
  default     = {}
}

variable "path_route_sets" {
  description = "To provision Load Balancer Path Route Sets"
  type        = map(any)
  default     = {}
}

variable "rule_sets" {
  description = "To provision Load Balancer Rule Sets"
  type        = map(any)
  default     = {}
}

variable "lbr_reserved_ips" {
  description = "To provision Load Balancer Reserved IPs"
  type        = map(any)
  default     = {}
}

###################################
####### Load Balancer Logs ########
###################################

variable "loadbalancer_log_groups" {
  description = "To provision Log Groups for Load Balancers"
  type        = map(any)
  default     = {}
}

variable "loadbalancer_logs" {
  description = "To provision Logs for Load Balancers"
  type        = map(any)
  default     = {}
}

#########################
## Network Load Balancers ##
#########################

variable "network_load_balancers" {
  type    = map(any)
  default = {}
}
variable "nlb_listeners" {
  type    = map(any)
  default = {}
}

variable "nlb_backend_sets" {
  type    = map(any)
  default = {}
}
variable "nlb_backends" {
  type    = map(any)
  default = {}
}
variable "nlb_reserved_ips" {
  description = "To provision Network Load Balancer Reserved IPs"
  type        = map(any)
  default     = {}
}


#########################
##### IP Management #####
#########################

variable "public_ip_pools" {
  type    = map(any)
  default = {}
}

variable "private_ips" {
  type    = map(any)
  default = {}
}

variable "reserved_ips" {
  type    = map(any)
  default = {}
}

variable "vnic_attachments" {
  type    = map(any)
  default = {}
}


######################### END #########################
