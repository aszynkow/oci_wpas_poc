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

data "oci_certificates_management_certificate" "lb_certificate" {
    #Required
    certificate_id = var.lb_certificate_id
    compartment_id           = var.compartment_ocid
}

# ------ Get List Images
data "oci_core_images" "Okit_In001Images" {
    compartment_id           = var.compartment_ocid
    operating_system         = "Oracle Linux Cloud Developer"
    operating_system_version = "8"
    shape                    = "VM.Standard.E3.Flex"
}

# ------ Get List Service OCIDs
data "oci_core_services" "RegionServices" {
}

# ------ Get List Images
data "oci_core_images" "InstanceImages" {
    compartment_id           = var.compartment_ocid
}

data "oci_identity_regions" "Regions" {
}

# value = data.oci_identity_region_subscriptions.HomeRegion.region_subscriptions
#}
#data "oci_identity_tenancy" "Tenancy" {
#    tenancy_id = var.tenancy_ocid
#}
