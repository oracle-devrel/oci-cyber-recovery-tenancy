// Copyright (c) 2021, 2022, Oracle and/or its affiliates.
#############################
# Network
# Backend Sets - tfvars
# Allowed Values:
# load_balancer_id can be ocid or the key of load_balancers (map)
# protocols in ssl configuration defaults to "TLSv1","TLSv1.1","TLSv1.2"
# Sample import command for Backend Sets:
# terraform import "module.backend-sets[\"<<backend_sets terraform variable name>>\"].oci_load_balancer_backend_set.backend_set" loadBalancers/<<loadbalancer ocid>>/backendSets/<<backendset name>>
#############################
backend_sets = {
  PRD_CON_MGR_LB_PRD_BASTION_SSH_BS = {
    name                              = "Name"
    load_balancer_id                  = "LB-Name"
    policy                            = "ROUND_ROBIN"
    protocol                          = "TCP"
    interval_ms                       = ""
    port                              = "22"
    response_body_regex               = ""
    retries                           = ""
    return_code                       = ""
    timeout_in_millis                 = ""
    url_path                          = ""
    lb_cookie_session                 = []
    session_persistence_configuration = []
    certificate_name                  = ""
    cipher_suite_name                 = ""
    ssl_configuration                 = []
  },
  ##Add New Backends for london here##
}
