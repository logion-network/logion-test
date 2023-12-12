#!/bin/bash

set -e

function print_section()
{
    echo ""
    echo "*******************************************"
    echo "* $1"
    echo "*"
}

# Retrieve journal (is sent by e-mail in production)
print_section "Saving journal..."
mkdir -p /tmp/work/
JOURNAL=/tmp/work/journal.txt
docker cp logion-test_backup_manager1_1:/opt/logion-pg-backup-manager/work/journal.txt $JOURNAL

# Kill node1
print_section "Killing node1..."
docker compose stop private-database1 node1 backup_manager1 backend1 frontend1
docker compose rm -f private-database1 node1 backup_manager1 backend1 frontend1
docker volume rm logion-test_db_backup logion-test_db_data

# Re-create a database
print_section "Re-creating node1 database..."
docker compose up -d private-database1
sleep 1 # Wait for postgres to be ready

# Put journal in manager's data volume
print_section "Preparing node1 data restore..."
docker run -d -it -v logion-test_db_backup:/opt/logion-pg-backup-manager/work --name logion-test_init-manager busybox sh
docker cp $JOURNAL logion-test_init-manager:/opt/logion-pg-backup-manager/work/journal.txt
docker stop logion-test_init-manager && docker rm logion-test_init-manager

# Actually restore the data
print_section "Restoring node1 data..."
docker run --rm -v logion-test_db_backup:/opt/logion-pg-backup-manager/work -v $(pwd)/config/.pgpass:/root/.pgpass --env-file .backup.env --network logion-test_default -e RESTORE_AND_CLOSE=true logionnetwork/logion-pg-backup-manager:latest

# Start services
print_section "Starting node1 node and backend..."
docker compose up -d node1 backend1 frontend1 backup_manager1

##################################################################################################
# In production, someone should check now that the node is behaving well again before proceeding #
##################################################################################################

# Put manager back into automatic mode (restore forces manual mode)
print_section "Resume automatic backup..."
docker compose exec backup_manager1 bash -c 'echo "Backup" > /opt/logion-pg-backup-manager/work/command.txt'
