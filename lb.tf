## This configuration was generated by terraform-provider-oci

resource oci_load_balancer_load_balancer hss_wpaspoclb {
  compartment_id = var.compartment_ocid
  display_name = local.lb_name#"wpaspoclb"
  freeform_tags = var.freeform_tags
  ip_mode    = "IPV4"
  is_private = "true"
  network_security_group_ids = [
    oci_core_network_security_group.nsglb01.id,
  ]
  #reserved_ips = <<Optional value not found in discovery>>
  shape = var.lb_shape#"flexible"
  shape_details {
    maximum_bandwidth_in_mbps = var.maximum_bandwidth_in_mbps#"10"
    minimum_bandwidth_in_mbps = var.minimum_bandwidth_in_mbps#"10"
  }
  subnet_ids = [
    oci_core_subnet.hss_wpaspoclbsub.id,
  ]
}

resource oci_load_balancer_listener hss_wpaspoclb_wpaspoclblsnr01 {
  connection_configuration {
    backend_tcp_proxy_protocol_version = "0"
    idle_timeout_in_seconds            = "60"
  }
  default_backend_set_name = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  hostname_names = [
  ]
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  name             = local.lstn1_name#"wpaspoclblsnr01"
  #path_route_set_name = <<Optional value not found in discovery>>
  port     = "80"
  protocol = "HTTP"
  #routing_policy_name = <<Optional value not found in discovery>>
  rule_set_names = [
  ]
}

resource oci_load_balancer_listener hss_wpaspoclb_wpaspoclblsnr02 {
  count         = var.lb_certificate_id != null ? 1 : 0
  connection_configuration {
    backend_tcp_proxy_protocol_version = "0"
    idle_timeout_in_seconds            = "60"
  }
  default_backend_set_name = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  hostname_names = [
  ]
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  name             = local.lstn2_name#"wpaspoclblsnr02"
  #path_route_set_name = <<Optional value not found in discovery>>
  port     = "443"
  protocol = "HTTP"
  #routing_policy_name = <<Optional value not found in discovery>>
  rule_set_names = [
  ]
  ssl_configuration {
    certificate_ids = [
      local.lb_certificate_id ,
    ]
    #certificate_name  = "webpoccert1"
    cipher_suite_name = "oci-default-ssl-cipher-suite-v1"
    protocols = [
      "TLSv1.2",
    ]
    server_order_preference = "DISABLED"
    trusted_certificate_authority_ids = [
    ]
    verify_depth            = "1"
    verify_peer_certificate = "false"
  }
}

resource oci_load_balancer_backend_set hss_wpaspoclbbs01 {
  health_checker {
    interval_ms         = "10000"
    port                = "80"
    protocol            = "HTTP"
    response_body_regex = ""
    retries             = "3"
    return_code         = "200"
    timeout_in_millis   = "3000"
    url_path            = var.healthch_url_path#"/wpas/Login.html"
  }
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  name             = local.bcknd1_name#"wpaspoclbbs01"
  policy           = "ROUND_ROBIN"
}

resource oci_load_balancer_backend hss_APP162 {
  backendset_name  = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  backup           = "false"
  drain            = "false"
  ip_address       = oci_core_instance.APP162.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  offline          = "false"
  port             = "80"
  weight           = "1"
}
/*
resource oci_load_balancer_backend hss_10-43-4-13-80 {
  backendset_name  = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  backup           = "false"
  drain            = "false"
  ip_address       = "10.43.4.13"
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  offline          = "false"
  port             = "80"
  weight           = "1"
}

resource oci_load_balancer_backend hss_10-43-4-23-80 {
  backendset_name  = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  backup           = "false"
  drain            = "false"
  ip_address       = "10.43.4.23"
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  offline          = "false"
  port             = "80"
  weight           = "1"
}

resource oci_load_balancer_backend hss_10-43-4-15-80 {
  backendset_name  = oci_load_balancer_backend_set.hss_wpaspoclbbs01.name
  backup           = "false"
  drain            = "false"
  ip_address       = "10.43.4.15"
  load_balancer_id = oci_load_balancer_load_balancer.hss_wpaspoclb.id
  offline          = "false"
  port             = "80"
  weight           = "1"
}*/

