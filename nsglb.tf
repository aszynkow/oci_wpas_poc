resource oci_core_network_security_group nsglb01 {
  compartment_id = var.compartment_ocid
  display_name = local.nsglb1_name
  freeform_tags = var.freeform_tags
  vcn_id = local.Okit_Vcn001_id
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_1 {
  description = "HTTPS traffic to private LB from on-prem"
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  source                    = var.on_prem_ip_range
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_2 {
  description               = "Egress HTTPS traffic from private LB to on-prem"
  destination               = var.on_prem_ip_range
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  #source = <<Optional value not found in discovery>>
  source_type = ""
  stateless   = "false"
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_3 {
  description               = "LB egress"
  destination               = var.sub01_ip_range
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  #source = <<Optional value not found in discovery>>
  source_type = ""
  stateless   = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_4 {
  #description = <<Optional value not found in discovery>>
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  source                    = var.on_prem_ip_range
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_5 {
  #description = <<Optional value not found in discovery>>
  destination               = var.on_prem_ip_range
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  #source = <<Optional value not found in discovery>>
  source_type = ""
  stateless   = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_6 {
  description = "Callan Testing allow rules. Cleanup once clarified."
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  source                    = var.on_prem_ip_range2
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "80"
      min = "80"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_7 {
  description = "Callan Testing allow rules. Cleanup once clarified."
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "6"
  source                    = var.on_prem_ip_range2
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
  tcp_options {
    destination_port_range {
      max = "443"
      min = "443"
    }
    #source_port_range = <<Optional value not found in discovery>>
  }
}

resource oci_core_network_security_group_security_rule nsglb01_network_security_group_security_rule_8 {
  description = "CALLAN TEST ICMP RULE. CLEAN UP ONCE TESTING IS CONCLUDED."
  #destination = <<Optional value not found in discovery>>
  destination_type          = ""
  direction                 = "INGRESS"
  network_security_group_id = oci_core_network_security_group.nsglb01.id
  protocol                  = "1"
  source                    = var.on_prem_ip_range2
  source_type               = "CIDR_BLOCK"
  stateless                 = "false"
}