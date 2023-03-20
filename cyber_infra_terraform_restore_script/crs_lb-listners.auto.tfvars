listeners = {
  PRD_CON_MGR_LB_PRD_BASTION_SSH_LN = {
    name                     = "LN-Name"
    load_balancer_id         = "LB-Name"
    port                     = "22"
    protocol                 = "TCP"
    default_backend_set_name = "BS-Name"
    connection_configuration = []
    hostname_names           = []
    path_route_set_name      = null
    rule_set_names           = []
    routing_policy_name      = ""
    certificate_name         = ""
    cipher_suite_name        = ""
    ssl_configuration        = []
  },
  ##Add New Listeners for london here##
}
