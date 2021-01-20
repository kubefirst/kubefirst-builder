#!/usr/bin/env bash

###
# usage: ./ecr-login.sh "us-east-1" "123456789101.dkr.ecr.us-east-1.amazonaws.com"
###

set -e 

REGION=$1
ECR_REGISTRY_URL=$2

aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ECR_REGISTRY_URL
