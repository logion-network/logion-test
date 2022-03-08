#!/bin/bash

set -e

mkdir -p tools

# Install ipfs-cluster-ctl
(
    VERSION=0.14.5
    cd tools
    FILE_NAME=ipfs-cluster-ctl_v${VERSION}_linux-amd64.tar.gz
    rm -f ${FILE_NAME}
    wget https://dist.ipfs.io/ipfs-cluster-ctl/v${VERSION}/${FILE_NAME}
    tar xzvf ${FILE_NAME}
    rm ${FILE_NAME}
)

# Install go-ipfs
(
    VERSION=0.12.0
    cd tools
    FILE_NAME=go-ipfs_v${VERSION}_linux-amd64.tar.gz
    wget https://dist.ipfs.io/go-ipfs/v${VERSION}/${FILE_NAME}
    tar xzvf ${FILE_NAME}
    rm ${FILE_NAME}
)
