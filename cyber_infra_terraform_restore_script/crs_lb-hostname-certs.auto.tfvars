load_balancers = {
  lb_1 = {
    display_name   = "lb_1"
    compartment_id = "compartment-name"
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
    ca_certificate     = "certs/cert.pem"
    passphrase         = ""
    private_key        = "certs/lbaas_privatekey/cert.pem"
    public_certificate = "certs/cert.pem"
  },
  ##Add New Certificates for london here##
}
