#!/bin/bash

set -x

export hostname_file=$1
export hostname=$2

echo $hostname_file
echo $hostname

cat <<EOF >$hostname_file
$2
EOF
