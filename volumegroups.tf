
resource oci_core_volume_group volgroup {
  availability_domain = local.ad
  backup_policy_id = oci_core_volume_backup_policy.gold_bckp_policy.id 
  compartment_id = var.compartment_ocid
  display_name = local.volgroup_name
  freeform_tags = var.freeform_tags
  source_details {
    type = "volumeIds"
    #volume_group_backup_id = <<Optional value not found in discovery>>
    #volume_group_id = <<Optional value not found in discovery>>
    volume_ids = [
     oci_core_volume.ocfs2_shared_10gb.id,
     oci_core_volume.ocfs2_shared.id,
     oci_core_instance.APP162[var.master_vm - 1].boot_volume_id
    ]
  }
}

resource oci_core_volume_group volgroup1 {
  count = local.vm_count - 1 
  availability_domain = local.ad
  backup_policy_id = oci_core_volume_backup_policy.bronze_bckp_policy.id 
  compartment_id = var.compartment_ocid
  display_name = join("",[local.volgroup_name,count.index]) 
  freeform_tags = var.freeform_tags
  source_details {
    type = "volumeIds"
    #volume_group_backup_id = <<Optional value not found in discovery>>
    #volume_group_id = <<Optional value not found in discovery>>
    volume_ids = [
     oci_core_instance.APP162[count.index].boot_volume_id
    ]
  }
}