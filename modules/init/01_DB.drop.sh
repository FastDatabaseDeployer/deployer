#!/bin/bash

# Variables
dropdb=${DEPLOYER_DB_DROP}
createdb=${DEPLOYER_DB_CREATE}
dbhost=${DEPLOYER_DB_HOST}
dbport=${DEPLOYER_DB_PORT}
dbname=${DEPLOYER_DB_NAME}
username=${DEPLOYER_DB_USERNAME}

echo
echo Drop DB \"$dbname\"
# psql --dbname=$dbname --username=$username --no-password --quiet --file=30_DB.0.sql --log-file=00_init.log
dropdb --host=$dbhost --port=$dbport --username=$username --no-password --echo --interactive --if-exists --force $dbname
