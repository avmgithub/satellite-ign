data "local_file" "ifcfg_template" {
  filename = "./templates/ifcfg.template"
}

# Demo ignition file from satellite location attach.
# This file needs to be populated with the correct details to boot RHCOS properly
data "local_file" "sat_attach_template" {
  filename = "./templates/attachHost-satellite-location.ign.template"
}

data "local_file" "sat_user_template" {
  filename = "./templates/satelliteUser.ign.template"
}

data "local_file" "storage_template" {
  filename = "./templates/storage.ign.template"
}

data "local_file" "ssh_public_key" {
  filename = "./ssh/id_rsa.pub"
}

# data "local_file" "etc_hostname" {
#   count = length(var.ip_addrs)
#   filename = "./hostname.${count.index}"
# }

/*
data "local_file" "ifcfg" {
  depends_on = [resource.null_resource.configure_ifcfg]

  count    = length(var.host_details)
  filename = "./ifcfg.${count.index}"
}
*/

# file and content to add to the ignition template for login to nodes
data "local_file" "sat_user_file" {
  filename = null_resource.add_sshkey_satuser.triggers.filename
}

/*
data "local_file" "hostname_files" {
  depends_on = [resource.null_resource.create_hostname_file]

  count = length(var.host_details)
  filename = "./hostname.${count.index}"
}

# ignition files for deploying VMs
data "local_file" "host_attach_ign_files" {
  depends_on = [resource.null_resource.create_hostname_file]

  count = length(var.host_details)
  filename = "./host_ign_file.${count.index}"
}
*/

/*
resource "null_resource" "configure_ifcfg" {
#  for_each = toset(var.ip_addrs)
  for_each = { for i, hd in var.host_details : i => hd }
  provisioner "local-exec" {
    command                   = <<EOT
./scripts/echo.sh ${each.key} ${each.value.ip_addr}  ${data.local_file.ifcfg_template.filename}
EOT
  }
}
*/

resource "null_resource" "add_sshkey_satuser" {

  triggers = {
    filename = "./templates/satelliteUser.ign"
  }
  provisioner "local-exec" {
    command = <<EOT
./scripts/addsshkey.sh "${data.local_file.ssh_public_key.content}" ${data.local_file.sat_user_template.filename} "./templates/satelliteUser.ign"
EOT
  }
}

# Creates /etc/hostname file that will end up inside each VM node
# $output_hostname_file=$1
# $hostname=$2
/*
resource "null_resource" "create_hostname_file" {
  for_each = { for i, hd in var.host_details : i => hd }
  provisioner "local-exec" {
    command                   = <<EOT
./scripts/create_hostname_file.sh "hostname.${each.key}" ${each.value.hostname}
EOT
  }
}
*/

# Creates ignition files that will be passed on during VM node creation
#  storage_template=$1
#  addl_storage_file=$2
#  hostname_base64_content=$3
#  ifcfg_base64_content=$4
#  satellite_attach_template=$5
#  host_ign_file=$6
/*
resource "null_resource" "create_ign_files" {
  for_each = { for i, hd in var.host_details : i => hd }
  provisioner "local-exec" {
    command                   = <<EOT
./scripts/create_ign_files.sh ${data.local_file.storage_template.filename} "addl_storage_file.${each.key}" ${data.local_file.hostname_files[each.key].content_base64} ${data.local_file.ifcfg[each.key].content_base64} ${data.local_file.sat_attach_template.filename} "host_ign_file.${each.key}" "${data.local_file.ssh_public_key.content}"
EOT
  }
}
*/
