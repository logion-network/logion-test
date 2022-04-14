#!/bin/bash

set -e

mkdir -p db_data
sudo chown -R 999:999 db_data # Make sure that the directory has proper ownership for the postgresql container
docker-compose up -d

sleep 3 # Wait for the directory service to be up

DIRECTORY_DB_HOST_IP=$(docker inspect logion-test_directory-database_1 | jq -r '.[0].NetworkSettings.Networks."logion-test_directory-net".IPAddress')

export PGPASSWORD=secret
psql -h $DIRECTORY_DB_HOST_IP -p 5432 -U postgres postgres < scripts/directory_data.sql
unset PGPASSWORD
