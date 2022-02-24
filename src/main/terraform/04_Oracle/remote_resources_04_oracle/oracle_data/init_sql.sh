#!/usr/bin/env bash

export ORACLE_SID=ORCLCDB

sqlplus -s /nolog <<EOF
connect sys/oracle as sysdba

@/home/oracle/oracle_data/init.sql

exit;
EOF

sleep 5
