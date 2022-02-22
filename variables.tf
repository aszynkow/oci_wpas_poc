variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}
variable service_dest {
    default = "all-syd-services-in-oracle-services-network"
}

variable vcn_ip_range {
    default = "10.43.4.0/23"
}

variable sub01_ip_range {
    default = "10.43.4.0/27"
}

variable sub02_ip_range {
    default = "10.43.4.32/27"
}

variable lb_subnet_cidr {
    default = "10.43.4.96/27"
}

variable sub03_ip_range {
    default = "10.43.4.64/27"
}

variable on_prem_ip_range {
    default = "10.42.0.0/16"
}

variable on_prem_ip_range2 {
    default = "10.0.0.0/8"
}

variable azure_range_01 {
    default = "10.45.0.0/16"
}

variable drg1_id {
    default = "ocid1.drg.oc1.ap-sydney-1.aaaaaaaa2nyev6iwogcz7mxofwjhpxq5qehs5lds45pgrcigytvlv5zn3asq"
}

variable ssh_authorized_keys {
    default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCgGSK4Q1fDVHojkHxDXJDz8bgEZ4+kWhAWG0TMNYovpG6pJe9TM0s0Qo7iZYxKaj0utY9WisptIS9nzBX7Mhb36QI4Je/i7MlMO+f5Vfsol5isjRlObDiW2GcoPL+EZIdNUgU8R3ovaUGcsx8dM4+RWQw/LKhbsYMWiFJwFr1e0ETnMM4WaZfyKM7uyq5SubEaoPiflwCueXksE5pSeuP/ov3Q82UkX2XZGjDALcMmE6xI91to64WLvovHmg7xmQZr0lsiyKiA3AaXVGuB95/Ngeq4e6DU4OZy1aDC2gyyW2jTpPwvbXbcki12ISuzkr+XRn0XS1hxrFhqIjFd1Ggt adam_szynk@d54895260571"
}

variable env_name {
    default = "wpaspoc"
}

variable freeform_tags {
    type = map
    default = {"WPASS_PROD"="GGADW"}
}
variable vm1_name {
    default = "LUORSHSSAPP004"
}

variable lb_certificate_id {
    default = "ocid1.certificate.oc1.ap-sydney-1.amaaaaaajdjgirqalqg4ypm2qymu5muglfowkzpusp6uubqtnejazof62nkq"
}
/*variable net_compartment_id { 
    default = "ocid1.compartment.oc1..aaaaaaaa2ewhxsftfwfneh2q5rwohakwlfu4jvnaolmqz465hzue7yx53ora"
}*/
       