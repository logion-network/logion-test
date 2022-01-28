#!/bin/bash

set -e

docker-compose down
./scripts/start.sh
