#!/bin/bash

# Variables
dropdb=${DEPLOYER_DB_DROP}
createdb=${DEPLOYER_DB_CREATE}
dbhost=${DEPLOYER_DB_HOST}
dbport=${DEPLOYER_DB_PORT}
dbname=${DEPLOYER_DB_NAME}
username=${DEPLOYER_DB_USERNAME}

echo
echo Create DB \"$dbname\"
# psql --host=$dbhost --port=$dbport --dbname=$dbname --username=$username --no-password --quiet --file=30_DB.1.nix.sql --log-file=00_init.log
tablespace="pg_default"
encoding="UTF8"
lc_collate="ru_RU.UTF-8"
lc_ctype="ru_RU.UTF-8"
owner="role_owner"
template="template0"
# description="Template Database of the "FastDatabaseDeployer" project"
createdb --host=$dbhost --port=$dbport --username=$username --no-password --tablespace=$tablespace --echo --owner=$owner --template=$template --encoding=$encoding --lc-collate=$lc_collate --lc-ctype=$lc_ctype $dbname '$description'
psql --host=$dbhost --port=$dbport --dbname=$dbname --username=$username --no-password --quiet --file=01_DB.alter.sql --log-file=00_init.log

