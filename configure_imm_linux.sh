#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
CWD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

mkdir -p /tmp/asu_output/ 2>/dev/null
rm -rf /tmp/asu_output/* 2>/dev/null

wget https://raw.githubusercontent.com/wnpower/IBM_IMM/master/bin/linux/ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz -O /tmp/asu_output/ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz
cd /tmp/asu_output/ && tar zvfz ibm_utl_asu_asut86h-9.64_linux_x86-64.tgz


