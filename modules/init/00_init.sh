#!/bin/bash

# Variables
dropdb=${DEPLOYER_DB_DROP}
createdb=${DEPLOYER_DB_CREATE}
dbhost=${DEPLOYER_DB_HOST}
dbport=${DEPLOYER_DB_PORT}
dbname=${DEPLOYER_DB_NAME}
username=${DEPLOYER_DB_USERNAME}

echo
echo Start Init

rm -f 00_init.log

if [ "$dropdb" == "yes" ]; then
    sh 01_DB.drop.sh
fi

if [ "$createdb" == "yes" ]; then
    sh 01_DB.create.sh
fi

psql --host=$dbhost --port=$dbport --dbname=$dbname --username=$username --no-password --quiet --file=00_init.sql --log-file=00_init.log

echo Finish Init
echo
