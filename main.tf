#output "Home_Region" {
locals {
#    HomeRegion = [for x in data.oci_identity_region_subscriptions.RegionSubscriptions.region_subscriptions: x if x.is_home_region][0]
#    home_region = lookup(
#        {
#            for r in data.oci_identity_regions.Regions.regions : r.key => r.name
#        },
#        data.oci_identity_tenancy.Tenancy.home_region_key
#    )
    home_region = lookup(element(data.oci_identity_region_subscriptions.HomeRegion.region_subscriptions, 0), "region_name")

    lb_certificate_id = data.oci_certificates_management_certificate.lb_certificate.id

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

    lb_name = join("",[local.env_name,"lb"])
    lbsl_name = join("",[local.env_name,"lbsl1"])
    lstn1_name = join("",[local.env_name,"lstn1"])
    lstn2_name = join("",[local.env_name,"lstn2"])
    nsglb1_name = join("",[local.env_name,"nsglb1"])
    bcknd1_name = join("",[local.env_name,"bcknd1"])
    lbsubnet_name = join("",[local.env_name,"lbsub"])
    lbdns_name = join("",[local.env_name,"lbsub"])
    lbrt_name = join("",[local.env_name,"lbrt"])

    bastion_name = join("",[local.env_name,"bst1"])

}