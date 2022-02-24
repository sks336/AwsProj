#!/usr/bin/env bash

#############################################
# THIS SCRIPT MUST RUN AS ORACLE USER
#############################################

export ORACLE_SID=ORCLCDB
export PATH=$PATH:$ORACLE_HOME/bin
mkdir -p /opt/oracle/oradata/recovery_area
mkdir -p /opt/oracle/oradata/orcl
chown -R oracle. /opt/oracle/oradata


sqlplus /nolog <<- EOF
CONNECT / AS SYSDBA
alter user sys identified by oracle;
alter user system identified by oracle;
alter system set db_recovery_file_dest_size = 50G;
alter system set db_recovery_file_dest = '/opt/oracle/oradata/recovery_area' scope=spfile;
shutdown immediate
startup mount
alter database archivelog;
alter database open;
-- Should show "Database log mode: Archive Mode"
archive log list
exit;
EOF

echo 'Applied db archive.....'

sleep 20


sqlplus sys/oracle@//localhost:1521/$ORACLE_SID as sysdba <<- EOF
  ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
  ALTER PROFILE DEFAULT LIMIT FAILED_LOGIN_ATTEMPTS UNLIMITED;
  exit;
EOF


sqlplus sys/oracle@//localhost:1521/$ORACLE_SID as sysdba <<- EOF
  CREATE TABLESPACE LOGMINER_TBS DATAFILE '/opt/oracle/oradata/orcl/logminer_tbs.dbf' SIZE 25M REUSE AUTOEXTEND ON MAXSIZE UNLIMITED;
  exit;
EOF


sqlplus sys/oracle@//localhost:1521/$ORACLE_SID as sysdba <<- EOF
  CREATE USER dbzuser IDENTIFIED BY dbz DEFAULT TABLESPACE LOGMINER_TBS QUOTA UNLIMITED ON LOGMINER_TBS;
  GRANT CREATE SESSION TO dbzuser;
  GRANT SET CONTAINER TO dbzuser;
  GRANT SELECT ON V_\$DATABASE TO dbzuser;
  GRANT FLASHBACK ANY TABLE TO dbzuser;
  GRANT SELECT ANY TABLE TO dbzuser;
  GRANT SELECT_CATALOG_ROLE TO dbzuser;
  GRANT EXECUTE_CATALOG_ROLE TO dbzuser;
  GRANT SELECT ANY TRANSACTION TO dbzuser;
  GRANT SELECT ANY DICTIONARY TO dbzuser;
  GRANT LOGMINING TO dbzuser;
  GRANT CREATE TABLE TO dbzuser;
  GRANT LOCK ANY TABLE TO dbzuser;
  GRANT CREATE SEQUENCE TO dbzuser;
  GRANT EXECUTE ON DBMS_LOGMNR TO dbzuser;
  GRANT EXECUTE ON DBMS_LOGMNR_D TO dbzuser;
  GRANT SELECT ON V_\$LOGMNR_LOGS TO dbzuser;
  GRANT SELECT ON V_\$LOGMNR_CONTENTS TO dbzuser;
  GRANT SELECT ON V_\$LOGFILE TO dbzuser;
  GRANT SELECT ON V_\$ARCHIVED_LOG TO dbzuser;
  GRANT SELECT ON V_\$ARCHIVE_DEST_STATUS TO dbzuser;
  exit;
EOF

sleep 5