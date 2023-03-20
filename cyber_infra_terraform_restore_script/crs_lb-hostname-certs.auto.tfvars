load_balancers = {
  PRD_CON_MGR_LB = {
    display_name   = "PRD_CON_MGR_LB"
    compartment_id = "CRS--CRS_RecoveryRooms--CRS_APP_EBS--CRS_APP_RedRoom"
    shape          = "flexible"
    shape_details = [{
      #Required
      maximum_bandwidth_in_mbps = 100
      minimum_bandwidth_in_mbps = 10
    }]
    network_compartment_id = "Network-Compartment-Name"
    vcn_name               = "VCN-Name"
    subnet_names           = ["Subnet-Name"]
    nsg_ids                = []
    is_private             = true
    reserved_ips_id        = "N"
    ip_mode                = "IPV4"
    defined_tags           = {}
    freeform_tags          = {}
  },
  ##Add New Hostnames for london here##
}
// Copyright (c) 2021, 2022, Oracle and/or its affiliates.
#############################
# Network
# Certificates - tfvars
# Allowed Values:
# load_balancer_id can be ocid or the key of load_balancers (map)
# Sample import command for Certificates:
# terraform import "module.certificates[\"<<certificates terraform variable name>>\"].oci_load_balancer_certificate.certificate" loadBalancers/<<loadbalancer ocid>>/certificates/<<certificate name>>
#############################
certificates = {
  PRD_EBS_BACS_LB_asserter_ssl_cert_cert = {
    certificate_name   = "Certname"
    load_balancer_id   = "LB-Name"
    ca_certificate     = "certs/asserter_lbaas_cert.pem"
    passphrase         = ""
    private_key        = "certs/lbaas_privatekey/asserter_private.pem"
    public_certificate = "certs/asserter_lbaas_cert.pem"
  },
  ##Add New Certificates for london here##
}
