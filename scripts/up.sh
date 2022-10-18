#!/bin/bash

set -e

docker-compose up -d private-database1
sleep 1 # Wait for postgres to be ready
chmod 600 config/.pgpass # Without this, the pg clients used by the backup manager will fail
docker-compose up -d
