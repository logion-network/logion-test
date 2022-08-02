#!/bin/bash

set -e

docker-compose up -d private-database1
sleep 1 # Wait for postgres to be ready
chmod 600 config/.pgpass # Without this, the pg clients used by the backup manager will fail
docker-compose up -d

sleep 3 # Wait for the directory service to be up

docker exec -i logion-test_directory-database_1 psql -U postgres postgres < scripts/directory_data.sql
