#!/bin/bash
# Mifos to Mifos X

PDI_HOME="C:\Users\CON-LP-19\Desktop\Clients\data-integration"
KETTLE_JOBS_PATH="C:\move-to-mifosx\KettleJobs"
DEST_DB="secdepx"

MYSQL_ARGS="-u root -pmysql"

echo "USE $DEST_DB" | mysql $MYSQL_ARGS
mysql $MYSQL_ARGS $DEST_DB < $KETTLE_JOBS_PATH/main/load_mifosx_ddl.sql
mysql $MYSQL_ARGS $DEST_DB < $KETTLE_JOBS_PATH/main/load_mifosx_datatables.sql
mysql $MYSQL_ARGS $DEST_DB < $KETTLE_JOBS_PATH/main/data_table_registered.sql
mysql $MYSQL_ARGS $DEST_DB < $KETTLE_JOBS_PATH/main/load_mifosx_migration_stored_procedures.sql
mysql $MYSQL_ARGS $DEST_DB < $KETTLE_JOBS_PATH/main/load_mifosx_stage1_tables.sql

#$PDI_HOME/kitchen.sh /file:`readlink -f $KETTLE_JOBS_PATH/Stage1/Stage1.kjb`
