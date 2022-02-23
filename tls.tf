## Copyright (c) 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "tls_private_key" "ssh_key" {
  algorithm   = "RSA"
}

locals {

gen_public_key = tls_private_key.ssh_key.public_key_openssh)
gen_priv_key = tls_private_key.ssh_key.private_key_pem

}