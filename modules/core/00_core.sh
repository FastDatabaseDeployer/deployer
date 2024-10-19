#!/bin/bash

echo Deploy core

# Variables
username=${DEPLOYER_INIT_DB_NAME}
dbhost=${DEPLOYER_DB_HOST}
dbport=${DEPLOYER_DB_PORT}
dbname=${DEPLOYER_DB_NAME}
username=${DEPLOYER_DB_USERNAME}

PGOPTIONS="-c client_min_messages=error"

rm -f 00_core.log

echo
echo Start deploy Core

psql --host=$dbhost --port=$dbport --dbname=$dbname --username=$username --no-password --quiet --file=00_core.sql --log-file=00_core.log

echo Finish deploy Core
echo
