/*resource oci_core_instance master {

  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  #async = <<Optional value not found in discovery>>
  availability_config {
    #is_live_migration_preferred = <<Optional value not found in discovery>>
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = local.ad
  #capacity_reservation_id = <<Optional value not found in discovery>>
  compartment_id = var.compartment_ocid
  create_vnic_details {
    #assign_private_dns_record = <<Optional value not found in discovery>>
    assign_public_ip = "false"
    display_name = var.vm_display_name[var.master_vm - 1]#"LPORSHSSAPP162"
    freeform_tags = var.freeform_tags
    hostname_label = var.vm_hostname[var.master_vm - 1]#"lporshssapp162"
    #private_ip             = "10.43.4.13"
    skip_source_dest_check = "false"
    subnet_id              = local.Okit_Sn001_id
    #vlan_id = <<Optional value not found in discovery>>
  }
  #dedicated_vm_host_id = <<Optional value not found in discovery>>
  display_name = var.vm_display_name[var.master_vm - 1]#"LPORSHSSAPP162"
  freeform_tags = var.freeform_tags
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  #ipxe_script = <<Optional value not found in discovery>>
  #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    #is_pv_encryption_in_transit_enabled = "false"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
        ssh_authorized_keys = local.ssh_authorized_keys #chomp(tls_private_key.ssh_key.public_key_openssh)
        #ssh_authorized_keys = var.ssh_authorized_keys
        user_data           = base64encode("")
  }
  #preserve_boot_volume = <<Optional value not found in discovery>>
  shape = var.vm_shape[var.master_vm -1 ]#"VM.Standard.E3.Flex"#"VM.Optimized3.Flex"
  shape_config {
    memory_in_gbs             = "64"
    ocpus                     = "4"
  }
  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs[var.master_vm -1 ]#"60"
    #kms_key_id = <<Optional value not found in discovery>>
    source_id   = var.vm_source_image_id[var.master_vm -1 ]
    source_type = var.vm_source_type[var.master_vm -1]#"bootVolume"
  }
  state = var.vm_state[var.master_vm - 1]#"RUNNING"
}
*/
resource oci_core_instance APP162 {

 count = local.vm_count #-1 

  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "OS Management Service Agent"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Run Command"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Block Volume Management"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Bastion"
    }
  }
  #async = <<Optional value not found in discovery>>
  availability_config {
    #is_live_migration_preferred = <<Optional value not found in discovery>>
    recovery_action = "RESTORE_INSTANCE"
  }
  availability_domain = local.ad
  #capacity_reservation_id = <<Optional value not found in discovery>>
  compartment_id = var.compartment_ocid
  create_vnic_details {
    #assign_private_dns_record = <<Optional value not found in discovery>>
    assign_public_ip = "false"
    display_name = var.vm_display_name[count.index]#"LPORSHSSAPP162"
    freeform_tags = var.freeform_tags
    hostname_label = var.vm_hostname[count.index]#"lporshssapp162"
    #private_ip             = "10.43.4.13"
    skip_source_dest_check = "false"
    subnet_id              = local.Okit_Sn001_id
    #vlan_id = <<Optional value not found in discovery>>
  }
  #dedicated_vm_host_id = <<Optional value not found in discovery>>
  display_name = var.vm_display_name[count.index]#"LPORSHSSAPP162"
  freeform_tags = var.freeform_tags
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  #ipxe_script = <<Optional value not found in discovery>>
  #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    #is_pv_encryption_in_transit_enabled = "false"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
        ssh_authorized_keys = local.ssh_authorized_keys #chomp(tls_private_key.ssh_key.public_key_openssh)
        #ssh_authorized_keys = var.ssh_authorized_keys
        user_data           = base64encode("")
  }
  #preserve_boot_volume = <<Optional value not found in discovery>>
  shape = var.vm_shape[count.index]#"VM.Standard.E3.Flex"#"VM.Optimized3.Flex"
  shape_config {
    memory_in_gbs             = "64"
    ocpus                     = "4"
  }
  source_details {
    boot_volume_size_in_gbs = var.boot_volume_size_in_gbs[count.index]#"60"
    #kms_key_id = <<Optional value not found in discovery>>
    source_id   = var.vm_source_image_id[count.index]
    source_type = var.vm_source_type[count.index]#"bootVolume"
  }
  state = var.vm_state[count.index]#"RUNNING"

  #depends_on = [oci_core_instance.master,]
}