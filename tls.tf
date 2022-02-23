## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "tls_private_key" "ssh_key" {
  count = var.ssh_authorized_keys != null ? 0 : 1
  algorithm   = "RSA"
}

locals {

gen_public_key = chomp(tls_private_key.ssh_key.[count.index]public_key_openssh)
gen_priv_key = tls_private_key.ssh_key[count.index].private_key_pem

}