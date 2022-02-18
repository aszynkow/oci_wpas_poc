# ------ Retrieve Regional / Cloud Data
# -------- Get a list of Availability Domains
data "oci_identity_availability_domains" "AvailabilityDomains" {
    compartment_id = var.compartment_ocid
}
data "template_file" "AvailabilityDomainNames" {
    count    = length(data.oci_identity_availability_domains.AvailabilityDomains.availability_domains)
    template = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains[count.index]["name"]
}
# -------- Get a list of Fault Domains
data "oci_identity_fault_domains" "FaultDomainsAD1" {
    availability_domain = element(data.oci_identity_availability_domains.AvailabilityDomains.availability_domains, 0)["name"]
    compartment_id = var.compartment_ocid
}
data "oci_identity_fault_domains" "FaultDomainsAD2" {
    availability_domain = element(data.oci_identity_availability_domains.AvailabilityDomains.availability_domains, 1)["name"]
    compartment_id = var.compartment_ocid
}
data "oci_identity_fault_domains" "FaultDomainsAD3" {
    availability_domain = element(data.oci_identity_availability_domains.AvailabilityDomains.availability_domains, 2)["name"]
    compartment_id = var.compartment_ocid
}
# -------- Get Home Region Name
data "oci_identity_region_subscriptions" "RegionSubscriptions" {
    tenancy_id = var.tenancy_ocid
}
data "oci_identity_region_subscriptions" "HomeRegion" {
    tenancy_id = var.tenancy_ocid
    filter {
        name = "is_home_region"
        values = [true]
    }
}
#output "Home_Region" {
# value = data.oci_identity_region_subscriptions.HomeRegion.region_subscriptions
#}
data "oci_identity_regions" "Regions" {
}
#data "oci_identity_tenancy" "Tenancy" {
#    tenancy_id = var.tenancy_ocid
#}

locals {
#    HomeRegion = [for x in data.oci_identity_region_subscriptions.RegionSubscriptions.region_subscriptions: x if x.is_home_region][0]
#    home_region = lookup(
#        {
#            for r in data.oci_identity_regions.Regions.regions : r.key => r.name
#        },
#        data.oci_identity_tenancy.Tenancy.home_region_key
#    )
    home_region = lookup(element(data.oci_identity_region_subscriptions.HomeRegion.region_subscriptions, 0), "region_name")
}
output "Home_Region_Name" {
 value = local.home_region
}
# ------ Get List Service OCIDs
data "oci_core_services" "RegionServices" {
}
# ------ Get List Images
data "oci_core_images" "InstanceImages" {
    compartment_id           = var.compartment_ocid
}

# ------ Home Region Provider
provider "oci" {
    alias            = "home_region"
    region           = local.home_region
}

# ------ Root Compartment
locals {
    DeploymentCompartment_id              = var.compartment_ocid
    #Network_comp_id = var.net_compartment_id
    env_name = var.env_name
    vcn_name = join("",[local.env_name,"vcn"])
    subnet_name = join("",[local.env_name,"appsub"])
    subnet_name_02 = join("",[local.env_name,"dbcltsub"])
    subnet_name_03 = join("",[local.env_name,"dbbkpsub"])
    igw_name = join("",[local.env_name,"igw"])
    sgw_name = join("",[local.env_name,"sgw"])
    nat_name = join("",[local.env_name,"nat"])
    sl1_name = join("",[local.env_name,"sl1"])
    sl2_name = join("",[local.env_name,"sl2"])
    rt1_name = join("",[local.env_name,"rt1"])
    rt2_name = join("",[local.env_name,"rt2"])
    drgat_name = join("",[local.env_name,"drgat"])
    nsg1_name = join("",[local.env_name,"nsg1"])
    dhcp_name = join("",[local.env_name,"dhcp"])
    vm1_name = var.vm1_name#join("",[local.env_name,"gg1vm"])
    vm2_name = join("",[local.env_name,"gg2vm"])
    drgrt_name = join("",[local.env_name,"drgrt"])
    sgwrt_name = join("",[local.env_name,"sgwrt"])

}

output "DeploymentCompartmentId" {
    value = local.DeploymentCompartment_id
}

# ------ Create Compartment - Root False
# ------ Create Compartment
/*resource "oci_identity_compartment" "Okit_Comp002" {
    provider       = oci.home_region
    #Required
    compartment_id = local.DeploymentCompartment_id
    description = "poccomp002"
    name   = "poccomp002"

    #Optional
    enable_delete = false
}
*/

locals {
    Okit_Comp002_id = local.DeploymentCompartment_id#oci_identity_compartment.Okit_Comp002.id
}

output "Okit_Comp002Id" {
    value = local.Okit_Comp002_id
}

# ------ Create Virtual Cloud Network
resource "oci_core_vcn" "Okit_Vcn001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    cidr_blocks    = [var.vcn_ip_range]
    # Optional
    dns_label      = local.vcn_name
    display_name   = local.vcn_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Vcn001_id                       = oci_core_vcn.Okit_Vcn001.id
    Okit_Vcn001_dhcp_options_id          = oci_core_vcn.Okit_Vcn001.default_dhcp_options_id
    Okit_Vcn001_domain_name              = oci_core_vcn.Okit_Vcn001.vcn_domain_name
    Okit_Vcn001_default_dhcp_options_id  = oci_core_vcn.Okit_Vcn001.default_dhcp_options_id
    Okit_Vcn001_default_security_list_id = oci_core_vcn.Okit_Vcn001.default_security_list_id
    Okit_Vcn001_default_route_table_id   = oci_core_vcn.Okit_Vcn001.default_route_table_id
}


# ------ Create Internet Gateway
/*resource "oci_core_internet_gateway" "Okit_Ig001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    enabled        = true
    display_name   = local.igw_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Ig001_id = oci_core_internet_gateway.Okit_Ig001.id
}
*/

# ------ Create NAT Gateway
resource "oci_core_nat_gateway" "Okit_Ng001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    display_name   = local.nat_name
    block_traffic  = false
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Ng001_id = oci_core_nat_gateway.Okit_Ng001.id
}


# ------ Create DRG
/*resource "oci_core_drg" "Okit_Drg001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    # Optional
    display_name   = "pocdrg001"
}
*/

locals {
    Okit_Drg001_id = var.drg1_id #oci_core_drg.Okit_Drg001.id
}

# ------ Create DRG Attachment
resource "oci_core_drg_attachment" "Okit_Drg001DRGAttachment" {
    drg_id        = local.Okit_Drg001_id
    vcn_id        = local.Okit_Vcn001_id
    #compartment_id = local.Okit_Comp002_id #local.Network_comp_id
    display_name   = local.drgat_name
    freeform_tags  =   var.freeform_tags
    route_table_id = local.Okit_drgrt_id
}


# ------ Create Network Security Group
/*resource "oci_core_network_security_group" "Okit_Nsg001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    # Optional
    display_name   = local.nsg1_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Nsg001_id = oci_core_network_security_group.Okit_Nsg001.id
}

# ------ Create Network Security Group Rules
resource "oci_core_network_security_group_security_rule" "Okit_Nsg001_Rule1" {
    # Required
    network_security_group_id = local.Okit_Nsg001_id
    direction    = "INGRESS"
    protocol    = "all"
    # Optional
    description   = ""
        source = "0.0.0.0/0"
        source_type  = "CIDR_BLOCK"
}

locals {
    Okit_Nsg001_Rule1_id = oci_core_network_security_group_security_rule.Okit_Nsg001_Rule1.id
}
resource "oci_core_network_security_group_security_rule" "Okit_Nsg001_Rule2" {
    # Required
    network_security_group_id = local.Okit_Nsg001_id
    direction    = "EGRESS"
    protocol    = "all"
    # Optional
    description   = ""
        destination = "0.0.0.0/0"
        destination_type  = "CIDR_BLOCK"
}

locals {
    Okit_Nsg001_Rule2_id = oci_core_network_security_group_security_rule.Okit_Nsg001_Rule2.id
}

*/
# ------ Create Security List
# ------- Update VCN Default Security List
resource "oci_core_default_security_list" "Okit_Sl001" {
    # Required
    manage_default_resource_id = local.Okit_Vcn001_default_security_list_id
    egress_security_rules {
        # Required
        protocol    = "all"
        destination = "0.0.0.0/0"
        # Optional
        destination_type  = "CIDR_BLOCK"
        description  = ""
    }
    ingress_security_rules {
        # Required
        protocol    = "6"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        description  = ""
        tcp_options {
            min = "22"
            max = "22"
        }
    }
    ingress_security_rules {
        # Required
        protocol    = "1"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        description  = ""
        icmp_options {
            type = "3"
            code = "4"
        }
    }
    ingress_security_rules {
        # Required
        protocol    = "1"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        description  = ""
        icmp_options {
            type = "3"
        }
    }
    # Optional
    display_name   = local.sl1_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Sl001_id = oci_core_default_security_list.Okit_Sl001.id
}


# ------ Create Security List
resource "oci_core_security_list" "Okit_Sl002" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    egress_security_rules {
        # Required
        protocol    = "all"
        destination = "0.0.0.0/0"
        # Optional
        destination_type  = "CIDR_BLOCK"
        description  = ""
    }
    ingress_security_rules {
        # Required
        protocol    = "all"
        source      = "0.0.0.0/0"
        # Optional
        source_type  = "CIDR_BLOCK"
        description  = ""
    }
    # Optional
    display_name   = local.sl2_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Sl002_id = oci_core_security_list.Okit_Sl002.id
}


# ------ Create Route Table
# ------- Update VCN Default Route Table
resource "oci_core_default_route_table" "Okit_Rt001" {
    # Required
    manage_default_resource_id = local.Okit_Vcn001_default_route_table_id
    #compartment_id = local.Okit_Comp002_id
    #vcn_id         = local.Okit_Vcn001_id
    route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = var.on_prem_ip_range
        network_entity_id = local.Okit_Drg001_id
        description       = ""
    }
    route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = var.azure_range_01
        network_entity_id = local.Okit_Drg001_id
        description       = ""
    }
    # Optional
    display_name   = local.rt1_name
}

locals {
    Okit_Rt001_id = oci_core_default_route_table.Okit_Rt001.id
    }


# ------ Create Route Table
resource "oci_core_route_table" "Okit_Rt002" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = "0.0.0.0/0"
        network_entity_id = local.Okit_Ng001_id
        description       = ""
    }
    route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = var.on_prem_ip_range
        network_entity_id = local.Okit_Drg001_id
        description       = "ON-prem"
    }

      route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = var.azure_range_01
        network_entity_id =local.Okit_Drg001_id
        description       = "Azure"
    }

    route_rules    {
        destination_type  = "SERVICE_CIDR_BLOCK"
        destination       = var.service_dest#lookup([for x in data.oci_core_services.RegionServices.services: x if substr(x.name, 0, 3) == var.service_name][0], "cidr_block")
        network_entity_id = local.Okit_Sg001_id
        description       = "OSN"
    }


    # Optional
    display_name   = local.rt2_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_Rt002_id = oci_core_route_table.Okit_Rt002.id
}


# ------ Get List Service OCIDs
locals {
    Okit_Sg001ServiceId = data.oci_core_services.RegionServices.services[1]["id"]#lookup([for x in data.oci_core_services.RegionServices.services: x if substr(x.name, 0, 3) == var.service_name][0], "id")
}

resource "oci_core_route_table" "Okit_drgrt" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id

    route_rules    {
        destination_type  = "SERVICE_CIDR_BLOCK"
        destination       = var.service_dest#lookup([for x in data.oci_core_services.RegionServices.services: x if substr(x.name, 0, 3) == var.service_name][0], "cidr_block")
        network_entity_id = local.Okit_Sg001_id
        description       = "OSN"
    }


    # Optional
    display_name   = local.drgrt_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_drgrt_id = oci_core_route_table.Okit_drgrt.id
}

resource "oci_core_route_table" "Okit_sgwrt" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id

   route_rules    {
        destination_type  = "CIDR_BLOCK"
        destination       = var.on_prem_ip_range
        network_entity_id = local.Okit_Drg001_id
        description       = "ON-prem"
    }

    # Optional
    display_name   = local.sgwrt_name
    freeform_tags  =   var.freeform_tags
}

locals {
    Okit_sgwrt_id = oci_core_route_table.Okit_sgwrt.id
}

# ------ Create Service Gateway
resource "oci_core_service_gateway" "Okit_Sg001" {
    # Required
    compartment_id = local.Okit_Comp002_id
    vcn_id         = local.Okit_Vcn001_id
    services {
        service_id = local.Okit_Sg001ServiceId
    }
    # Optional
    display_name   = local.sgw_name
    route_table_id = local.Okit_sgwrt_id
}

locals {
    Okit_Sg001_id = oci_core_service_gateway.Okit_Sg001.id
}


# ------ Create Dhcp Options
# ------- Update VCN Default Route Table
resource "oci_core_default_dhcp_options" "Okit_Do001" {
    # Required
    manage_default_resource_id = local.Okit_Vcn001_default_dhcp_options_id
    options    {
        type  = "DomainNameServer"
        server_type = "VcnLocalPlusInternet"
        custom_dns_servers       = []
    }
    options    {
        type  = "SearchDomain"
        search_domain_names      = [local.Okit_Vcn001_domain_name]
    }
    # Optional
    display_name   = local.dhcp_name
}

locals {
    Okit_Do001_id = oci_core_default_dhcp_options.Okit_Do001.id
    }


# ------ Create Subnet
# ---- Create Public Subnet
resource "oci_core_subnet" "Okit_Sn001" {
    # Required
    compartment_id             = local.Okit_Comp002_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.sub01_ip_range
    # Optional
    display_name               = local.subnet_name
    dns_label                  = local.subnet_name
    security_list_ids          = [local.Okit_Sl002_id]
    route_table_id             = local.Okit_Rt002_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = true
    freeform_tags              =   var.freeform_tags
}

locals {
    Okit_Sn001_id              = oci_core_subnet.Okit_Sn001.id
    Okit_Sn001_domain_name     = oci_core_subnet.Okit_Sn001.subnet_domain_name
}

resource "oci_core_subnet" "Okit_Sn002" {
    # Required
    compartment_id             = local.Okit_Comp002_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.sub02_ip_range
    # Optional
    display_name               = local.subnet_name_02
    dns_label                  = local.subnet_name_02
    security_list_ids          = [local.Okit_Sl002_id]
    route_table_id             = local.Okit_Rt002_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = true
    freeform_tags              =   var.freeform_tags
}

locals {
    Okit_Sn002_id              = oci_core_subnet.Okit_Sn002.id
    Okit_Sn002_domain_name     = oci_core_subnet.Okit_Sn002.subnet_domain_name
}

resource "oci_core_subnet" "Okit_Sn003" {
    # Required
    compartment_id             = local.Okit_Comp002_id
    vcn_id                     = local.Okit_Vcn001_id
    cidr_block                 = var.sub03_ip_range
    # Optional
    display_name               = local.subnet_name_03
    dns_label                  = local.subnet_name_03
    security_list_ids          = [local.Okit_Sl002_id]
    route_table_id             = local.Okit_Rt002_id
    dhcp_options_id            = local.Okit_Vcn001_dhcp_options_id
    prohibit_public_ip_on_vnic = true
    freeform_tags              =   var.freeform_tags
}

locals {
    Okit_Sn003_id              = oci_core_subnet.Okit_Sn003.id
    Okit_Sn003_domain_name     = oci_core_subnet.Okit_Sn003.subnet_domain_name
}


/* 
#Commenting as ORM cant handle OBO (issues rasoed with PM) 
# ------ Create Autonomous Database
resource "oci_database_autonomous_database" "Okit_Ad001" {
    #Required
    admin_password           = "J_LoWaGRosW4RyLL_VY3rk8vruRvHY"
    compartment_id           = local.Okit_Comp002_id
    cpu_core_count           = "1"
    data_storage_size_in_tbs = "1"
    db_name                  = "okitad001"

    #Optional
    display_name             = "pocad001"
    subnet_id                = local.Okit_Sn001_id
    nsg_ids                  = [local.Okit_Nsg001_id]
    db_workload              = "DW"
    is_auto_scaling_enabled  = tobool(lower(true))
    is_free_tier             = tobool(lower(false))
#    is_preview_version_with_service_terms_accepted = 
    license_model            = "BRING_YOUR_OWN_LICENSE"
    private_endpoint_label    = "pocad001"
    freeform_tags            =   var.freeform_tags
}
*/


# ------ Get List Images
data "oci_core_images" "Okit_In001Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = "Oracle Linux Cloud Developer"
    operating_system_version = "8"
    shape                    = "VM.Standard.E3.Flex"
}

# ------ Create Instance
resource "oci_core_instance" "Okit_In001" {
    # Required
    compartment_id      = local.Okit_Comp002_id
    shape               = "VM.Standard.E3.Flex"
    # Optional
    display_name        = local.vm1_name
    availability_domain = data.oci_identity_availability_domains.AvailabilityDomains.availability_domains["1" - 1]["name"]
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
}

output "Okit_In001PublicIP" {
    value = local.Okit_In001_public_ip
}

output "Okit_In001PrivateIP" {
    value = local.Okit_In001_private_ip
}

output "Exa_backup_subnet_id" {
    value = local.Okit_Sn003_id
}

output "Exa_client_subnet_id" {
    value = local.Okit_Sn002_id
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
# ------ Create Block Storage Attachments

# ------ Create VNic Attachments

