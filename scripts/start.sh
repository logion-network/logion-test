#!/bin/bash

set -e

docker-compose up -d

sleep 3

DB_HOST=$(docker inspect logion-test_directory-database_1 | jq -r '.[0].NetworkSettings.Networks."logion-test_directory-net".IPAddress')

export PGPASSWORD=secret
psql -h $DB_HOST -p 5432 -U postgres postgres < scripts/directory_data.sql
unset PGPASSWORD
