# ------ Home Region Provider
provider "oci" {
    alias            = "home_region"
    region           = local.home_region
}