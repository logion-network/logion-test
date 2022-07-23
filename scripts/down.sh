#!/bin/bash

set -e

docker-compose down
rm -rf db_backup db_data
