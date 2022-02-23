resource "oci_core_instance" "Okit_In001" {
    # Required
    compartment_id      = local.Okit_Comp002_id
    shape               = "VM.Standard.E3.Flex"
    # Optional
    display_name        = local.vm1_name
    availability_domain = local.ad
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Okit_Sn001_id
        # Optional
        assign_public_ip = false
        display_name     = local.vm1_name
        hostname_label   = local.vm1_name
        skip_source_dest_check = "false"
        freeform_tags    =  var.freeform_tags
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    metadata = {
        ssh_authorized_keys = local.ssh_authorized_keys #chomp(tls_private_key.ssh_key.public_key_openssh)
        #ssh_authorized_keys = var.ssh_authorized_keys
        user_data           = base64encode("")
    }
    shape_config {
        #Optional
        memory_in_gbs = 16
        ocpus = 1
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In001Images.images[0]["id"]
        source_type             = "image"
        # Optional
        boot_volume_size_in_gbs = "50"
#        kms_key_id              = 
    }
    preserve_boot_volume = false
    freeform_tags              =   var.freeform_tags
}

locals {
    Okit_In001_id            = oci_core_instance.Okit_In001.id
    Okit_In001_public_ip     = oci_core_instance.Okit_In001.public_ip
    Okit_In001_private_ip    = oci_core_instance.Okit_In001.private_ip
    aux_pub_key = oci_core_instance.Okit_In001.metadata.ssh_authorized_keys

}

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments

/*
# ------ Get List Images
data "oci_core_images" "Okit_In002Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = "Oracle Linux"
    operating_system_version = "8"
    shape                    = "VM.Standard.E3.Flex"
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In002" {
    # Required
    compartment_id      = local.Okit_Comp002_id
    shape               = "VM.Standard.E3.Flex"
    # Optional
    display_name        = local.vm2_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains["1" - 1]["name"]
    agent_config {
        # Optional
    }
    create_vnic_details {
        # Required
        subnet_id        = local.Okit_Sn001_id
        # Optional
        assign_public_ip = false
        display_name     = local.vm2_name
        hostname_label   = local.vm2_name
        skip_source_dest_check = "false"
        freeform_tags    =  var.freeform_tags
    }
#    extended_metadata {
#        some_string = "stringA"
#        nested_object = "{\"some_string\": \"stringB\", \"object\": {\"some_string\": \"stringC\"}}"
#    }
    metadata = {
        ssh_authorized_keys = var.ssh_authorized_keys
        user_data           = base64encode("")
    }
    shape_config {
        #Optional
        memory_in_gbs = 16
        ocpus = 1
    }
    source_details {
        # Required
        source_id               = data.oci_core_images.Okit_In002Images.images[0]["id"]
        source_type             = "image"
        # Optional
        boot_volume_size_in_gbs = "50"
#        kms_key_id              = 
    }
    preserve_boot_volume = false
    freeform_tags              =   var.freeform_tags
}

locals {
    Okit_In002_id            = oci_core_instance.Okit_In002.id
    Okit_In002_public_ip     = oci_core_instance.Okit_In002.public_ip
    Okit_In002_private_ip    = oci_core_instance.Okit_In002.private_ip
}

output "Okit_In002PublicIP" {
    value = local.Okit_In002_public_ip
}

output "Okit_In002PrivateIP" {
    value = local.Okit_In002_private_ip
}
*/