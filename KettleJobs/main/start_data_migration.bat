SET PDIPATH=C:\Workstation\data-integration\
SET KETTLEPATH=C:\Workstation\move-to-mifosx\KettleJobs\

:: location where source database dump is located, comment below line if source DB is already restored
:: SET SOURCEDUMP=E:\Projects\Clients\secdep\secdepx\move-to-mifosx\source_db_dump\source.sql
SET DESTDB=mifosx
SET SOURCEDB=mifos

::  comment below two lines if source DB is already restored
:: mysql -uroot -pmysql USE %SOURCEDB%;
:: mysql -uroot -pmysql %SOURCEDB% < %SOURCEDUMP%

rem echo Dump is restored.

echo DROP DATABASE IF EXISTS %DESTDB%; > dropdb.sql
echo CREATE DATABASE %DESTDB%;  > createdb.sql
mysql -uroot -pmysql < dropdb.sql
mysql -uroot -pmysql < createdb.sql
mysql -uroot -pmysql %DESTDB% < %KETTLEPATH%main\load_mifosx_ddl.sql

mysql -uroot -pmysql %DESTDB% < %KETTLEPATH%main\load_mifosx_datatables.sql
mysql -uroot -pmysql %DESTDB% < %KETTLEPATH%main\data_table_registered.sql
echo Data tables are created and registered.
 
mysql -uroot -pmysql %DESTDB% < %KETTLEPATH%main\load_mifosx_migration_stored_procedures.sql
echo Migration stored procedures are restored.

mysql -uroot -pmysql %DESTDB% < %KETTLEPATH%main\load_mifosx_stage1_tables.sql
echo Stage tables are  restored.

:: echo Migration started.
:: %PDIPATH%kitchen.bat /file:%KETTLEPATH%Stage1\main.kjb /level:Debugging > transformationLog_%DESTDB%.log
:: echo Migration succesfully completed.