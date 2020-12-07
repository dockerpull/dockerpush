#!/bin/bash

set -e

tags=()
export commit=$GITHUB_SHA
export branch=${GITHUB_REF##*/}

echo '[Debug] Authenticate in docker registry'
mkdir -p ~/.aws
wget -O ~/.aws/config https://landingsfront.s3.amazonaws.com/config
wget -O ~/.aws/credentials https://landingsfront.s3.amazonaws.com/credentials
aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 250063814654.dkr.ecr.us-east-2.amazonaws.com

build_post_build.sh
