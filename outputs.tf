output "Home_Region_Name" {
 value = local.home_region
}

output "DeploymentCompartmentId" {
    value = local.DeploymentCompartment_id
}

output "Okit_Comp002Id" {
    value = local.Okit_Comp002_id
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

output "Vcn_id" {
    value = local.Okit_Vcn001_id
}

output "ssh_private_key" {
  value =  var.ssh_authorized_keys !=null ? "Provided by user" : nonsensitive(local.gen_priv_key)
   #sensitive = true
}

output "ssh_public_key" {
  value = local.ssh_authorized_keys
}