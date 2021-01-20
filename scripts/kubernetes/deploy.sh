#!/usr/bin/env bash

###
# usage: ./build.sh "123456789101.dkr.ecr.us-east-1.amazonaws.com" "metaphor" "64187c550df11432f1efc279595f4fdbc97493cf"
###

set -ex

K8S_NAMESPACE=$1
K8S_DIR=$2
K8S_REGION=$3
K8S_CLUSTER_NAME=$4

aws eks --region "${K8S_REGION}" update-kubeconfig --name "${K8S_CLUSTER_NAME}"

kubectl apply -n "${K8S_NAMESPACE}" -f "${K8S_DIR}"
