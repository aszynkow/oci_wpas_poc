
resource oci_core_volume ocfs2_shared {
  availability_domain = local.ad
  #block_volume_replicas_deletion = <<Optional value not found in discovery>>
  compartment_id = var.compartment_ocid
  display_name = "ocfs2_shared"
 freeform_tags = var.freeform_tags
  is_auto_tune_enabled = "false"
  #kms_key_id = <<Optional value not found in discovery>>
  size_in_gbs = "300"
  #volume_backup_id = <<Optional value not found in discovery>>
  vpus_per_gb = "10"
}

resource oci_core_volume ocfs2_shared_10gb {
  availability_domain = local.ad
  #block_volume_replicas_deletion = <<Optional value not found in discovery>>
  compartment_id = var.compartment_ocid
  display_name = "ocfs2_shared_10gb"
  freeform_tags = var.freeform_tags
  is_auto_tune_enabled = "false"
  #kms_key_id = <<Optional value not found in discovery>>
  size_in_gbs = "50"
  #volume_backup_id = <<Optional value not found in discovery>>
  vpus_per_gb = "10"
}

resource oci_core_volume_attachment volumeattachment20220125063516 {
  count = local.vm_count
  attachment_type = "paravirtualized"
  device          = "/dev/oracleoci/oraclevdb"
  display_name    =  join("volumeattachmenocfs2",[count.index])
  #encryption_in_transit_type = <<Optional value not found in discovery>>
  instance_id                         = oci_core_instance.APP162[count.index].id
  is_pv_encryption_in_transit_enabled = "false"
  is_read_only                        = "false"
  #is_shareable = <<Optional value not found in discovery>>
  #use_chap = <<Optional value not found in discovery>>
  volume_id = oci_core_volume.ocfs2_shared.id
}

resource oci_core_volume_attachment volumeattachment20220207044931 {
  count = local.vm_count
  attachment_type = "paravirtualized"
  device          = "/dev/oracleoci/oraclevdc"
  display_name    = join("volumeattachmentocfs210",[count.index])
  #encryption_in_transit_type = <<Optional value not found in discovery>>
  instance_id                         = oci_core_instance.APP162[count.index].id
  is_pv_encryption_in_transit_enabled = "false"
  is_read_only                        = "false"
  #is_shareable = <<Optional value not found in discovery>>
  #use_chap = <<Optional value not found in discovery>>
  volume_id = oci_core_volume.ocfs2_shared_10gb.id
}