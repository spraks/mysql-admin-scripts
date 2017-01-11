#!/bin/sh
clear
echo "------------------------------------------------"
echo "Backup job start time : " `date`
NOW=$(date +"%Y%m%d")

# Database credentials 
HOST="127.0.0.1"
USER="backupuser"
PASSWORD="password"
DBNAME="mydatabase"

#Backup location
BACKUPPATH="/backup"

# Full schema
SCHEMATABLES=`mysql -h$HOST -u$USER -p$PASSWORD  -e  "Use $DBNAME; SHOW TABLES" | egrep -v '^Tables_in_mydatabase'  `

# Data export - exclude log_ tables data 
DATATABLES=`mysql -h$HOST -u$USER -p$PASSWORD  -e  "Use $DBNAME; SHOW TABLES" | egrep -v  '^log_' | egrep -v '^Tables_in_mydatabase' `


echo "Generating schema dump for mydatabase..."
 mysqldump -h$HOST -u$USER -p$PASSWORD $DBNAME $SCHEMATABLES --no-data --lock-tables=false > $BACKUPPATH/$DBNAME_schema_$NOW.sql

echo "DB Schema dump completed, now exporting data..."
 mysqldump -h$HOST -u$USER -p$PASSWORD $DBNAME $DATATABLES  --lock-tables=false > $BACKUPPATH/$DBNAME_data_$NOW.sql

echo "Data export job ompleted  : " `date`
echo "------------------------------------------------"
