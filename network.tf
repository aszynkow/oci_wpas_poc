
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
resource oci_core_subnet hss_wpaspoclbsub {
  #availability_domain = <<Optional value not found in discovery>>
  cidr_block     = var.lb_subnet_cidr
  compartment_id = var.compartment_ocid
  dhcp_options_id = oci_core_vcn.export_wpaspocvcn.default_dhcp_options_id
  display_name    = "wpaspoclbsub"
  dns_label       = "wpaspoclbsub"
  freeform_tags = var.freeform_tags
  #ipv6cidr_block = <<Optional value not found in discovery>>
  prohibit_internet_ingress  = "true"
  prohibit_public_ip_on_vnic = "true"
  route_table_id             = oci_core_route_table.hss_wpaspoclbrt.id
  security_list_ids = [
    oci_core_security_list.hss_empty.id,
  ]
  vcn_id = local.Okit_Vcn001_id   
}

resource oci_core_route_table hss_wpaspoclbrt {
  compartment_id = var.compartment_ocid
  display_name = "wpaspoclbrt"
  freeform_tags = var.freeform_tags
  route_rules {
    description       = "On Prem"
    destination       = var.onprem2
    destination_type  = "CIDR_BLOCK"
    network_entity_id = local.Okit_Drg001_id
  }
  vcn_id = local.Okit_Vcn001_id 
}

resource oci_core_security_list hss_empty {
  compartment_id = var.compartment_ocid
  display_name = local.lbsl_name
  egress_security_rules {
    #description = <<Optional value not found in discovery>>
    destination      = var.sub01_ip_range
    destination_type = "CIDR_BLOCK"
    #icmp_options = <<Optional value not found in discovery>>
    protocol  = "6"
    stateless = "false"
    tcp_options {
      max = "80"
      min = "80"
      #source_port_range = <<Optional value not found in discovery>>
    }
    #udp_options = <<Optional value not found in discovery>>
  }
  freeform_tags = var.freeform_tags
  vcn_id = local.Okit_Vcn001_id  
}


locals {
    Okit_Comp002_id = local.DeploymentCompartment_id#oci_identity_compartment.Okit_Comp002.id
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



# ------ Create Instance

# ------ Create Block Storage Attachments

# ------ Create VNic Attachments

