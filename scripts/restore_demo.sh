#!/bin/bash

set -e

function print_section()
{
    echo ""
    echo "*******************************************"
    echo "* $1"
    echo "*"
}

# Kill node1's private database
print_section "Killing node1..."
docker-compose stop private-database1
docker exec -i logion-test_backup_manager1_1 /bin/sh -c 'rm -Rf /opt/logion-pg-backup-manager/db_data/*'
docker-compose stop backup_manager1
docker-compose rm -f private-database1

# Re-create node1's private database
print_section "Restoring node1..."
docker-compose up -d private-database1
sleep 1 # Wait for postgres to be ready
docker-compose start backup_manager1
docker exec -i logion-test_backup_manager1_1 /bin/sh -c 'echo "Restore" > /opt/logion-pg-backup-manager/work/command.txt'
