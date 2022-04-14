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
docker-compose stop backup_manager1
docker-compose stop private-database1
docker-compose rm -f private-database1
sudo rm -rf db_data # Deletes DB state

# Re-create node1's private database
print_section "Restoring node1..."
docker-compose up -d private-database1
sleep 1 # Wait for postgres to be ready
echo "Restore" | sudo tee db_backup/command.txt > /dev/null # Trigger Restore on next backup manager trigger
docker-compose start backup_manager1
