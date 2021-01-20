#!/usr/bin/env bash

###
# usage: ./docker-image-retag.sh "123456789101.dkr.ecr.us-east-1.amazonaws.com" "metaphor" "64187c550df11432f1efc279595f4fdbc97493cf" "v0.2.0"
###

set -ex

ECR_REGISTRY_BASE_URL=$1
CI_PROJECT_NAME=$2
CI_COMMIT_SHA=$3
TAG_VERSION=$4

docker pull "${ECR_REGISTRY_BASE_URL}"/"${CI_PROJECT_NAME}":"${CI_COMMIT_SHA}"
docker tag "${ECR_REGISTRY_BASE_URL}"/"${CI_PROJECT_NAME}":"${CI_COMMIT_SHA}" "${ECR_REGISTRY_BASE_URL}"/"${CI_PROJECT_NAME}":"${TAG_VERSION}"
docker push "${ECR_REGISTRY_BASE_URL}"/"${CI_PROJECT_NAME}":"${TAG_VERSION}"