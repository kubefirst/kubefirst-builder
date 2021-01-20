#!/usr/bin/env bash

###
# usage: ./build.sh "123456789101.dkr.ecr.us-east-1.amazonaws.com" "metaphor" "64187c550df11432f1efc279595f4fdbc97493cf"
###

set -ex

ECR_REGISTRY_BASE_URL=$1
CI_PROJECT_NAME=$2
BUILD_IMAGE_VERSION=$3

docker build -t "${ECR_REGISTRY_BASE_URL}"/"${CI_PROJECT_NAME}":"${BUILD_IMAGE_VERSION}" .