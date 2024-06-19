#!/bin/bash

# Directory
docker compose exec -T private-database1 psql -U postgres postgres < scripts/llo_data_node1.sql
docker compose exec -T private-database2 psql -U postgres postgres < scripts/llo_data_node2.sql

# Authority list
node ./scripts/init_onchain_data.js
