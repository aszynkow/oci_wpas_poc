resource "oci_bastion_bastion" "wms_bastion" {
    #Required
	#count                        = var.use_bastion_service ? 1 : 0
    bastion_type = var.bastion_type
    compartment_id = local.Okit_Comp002_id
    target_subnet_id = local.Okit_Sn001_id

    #Optional
    client_cidr_block_allow_list = var.bastion_client_cidr_block_allow_list
    freeform_tags = var.freeform_tags
    max_session_ttl_in_seconds = var.max_session_ttl_in_seconds
    name = local.bastion_name
}