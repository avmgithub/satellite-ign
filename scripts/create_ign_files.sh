#!/bin/bash

set -x 

export storage_template=$1
export addl_storage_file=$2
export hostname_base64_content=$3
export ifcfg_base64_content=$4
export satellite_attach_template=$5
export host_ign_file=$6
export ssh_public_key=$7

TMP_FILENAME=$(mktemp)
TMP_IGN_FILE=$(mktemp)
TMP_IGN_FILE2=$(mktemp)


# replace the base64 content of hostname in the storage template file write it to a temp file
jq '.[0].contents.source = [ "'"data:text/plain;charset=utf-8;base64,$hostname_base64_content"'" ]' $storage_template > $TMP_FILENAME

# replace the ifcfg content of /etc/sysconfig/network-scripts/ifcfg-ens19 in the temp file and write output to addl_storage file
jq '.[1].contents.source = [ "'"data:text/plain;charset=utf-8;base64,$ifcfg_base64_content"'" ]' $TMP_FILENAME > $addl_storage_file

# the additional storage file output from previous command can then be added to the satellite attach ignition file
jq --argjson groupInfo "$(<$addl_storage_file)" '.storage.files += $groupInfo' $satellite_attach_template > $TMP_IGN_FILE

# add satuser to password and username in ignition file
jq --argjson groupInfo "$(<satelliteUser.ign)" '.passwd.users += [$groupInfo]' $TMP_IGN_FILE > $TMP_IGN_FILE2

# add ssh public key to core user
jq '.passwd.users[0].sshAuthorizedKeys = [ "'"$ssh_public_key"'" ]' $TMP_IGN_FILE2 > $host_ign_file

# cleanup
rm $TMP_FILENAME
rm $TMP_IGN_FILE
rm $TMP_IGN_FILE2