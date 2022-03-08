#!/bin/bash

set -e

function print_section()
{
    echo ""
    echo "*******************************************"
    echo "* $1"
    echo "*"
}

# Backup
print_section "Create backup"
docker-compose exec private-database1 bash -c "pg_dump -F c -U postgres postgres | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -pass env:ENC_PASSWORD > /db_backup/backup.dat"

# Store in IPFS
print_section "Store encryped backup file into private IPFS cluster"
RESULT=$( ./tools/ipfs-cluster-ctl/ipfs-cluster-ctl add ./db_backup/backup.dat --rmin 1 --rmax 2 --local )
CID=$( echo -e $RESULT | awk '{print $2}' )

# Kill node1's private database
print_section "Kill node1's private database"
docker-compose stop private-database1
docker-compose rm -f private-database1
docker-compose up -d

# Download backup from IPFS
print_section "Download encrypted backup file from private IPFS cluster"
./tools/go-ipfs/ipfs --api /ip4/127.0.0.1/tcp/5001 get $CID -o ./db_backup/downloaded.dat

# Restore
sleep 1 # Wait for postgres to be ready
print_section "Re-build node1's private database"
docker-compose exec private-database1 bash -c "cat /db_backup/downloaded.dat | openssl enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -pass env:ENC_PASSWORD -d | pg_restore -F c -U postgres -d postgres"
