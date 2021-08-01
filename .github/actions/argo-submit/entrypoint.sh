#!/usr/bin/env bash

LEASE_DURATION=900 # 15m default
AWS_DEFAULT_REGION=${AWS_DEFAULT_REGION:-us-east-2}
K8S_CLUSTER=${K8S_CLUSTER:-k8s-mgmt}
REPO_NAME=$(echo ${GITHUB_REPOSITORY} | cut -d/ -f2)
SHORT_SHA=$(echo ${GITHUB_SHA} | cut -c1-7)

# todo get the role and session name out of here
TMP_AWS_CREDS=$(aws sts assume-role --role-arn ${AWS_ROLE_TO_ASSUME} --role-session-name ${AWS_SESSION_NAME} --duration-seconds $LEASE_DURATION)
export AWS_SESSION_TOKEN=$(echo $TMP_AWS_CREDS | jq -r .Credentials.SessionToken)
export AWS_ACCESS_KEY_ID=$(echo $TMP_AWS_CREDS | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $TMP_AWS_CREDS | jq -r .Credentials.SecretAccessKey)

# get eks kubeconfig
aws eks update-kubeconfig --name ${K8S_CLUSTER} --region ${AWS_DEFAULT_REGION}

# set argo server envs
ARGO_SERVER=${ARGO_SERVER_URL}
ARGO_HTTP1='true'
ARGO_SECURE='true'
ARGO_BASE_HREF='/argo/'
ARGO_NAMESPACE='argo'
ARGO_TOKEN=$(argo auth token)

argo -n argo submit ${INPUT_WORKFLOW_YAML_PATH} \
  --parameter-file ${INPUT_PARAMETER_FILE_PATH} \
  --generate-name "${REPO_NAME}-publish-${SHORT_SHA}" \
  -p ciCommitSha="${GITHUB_SHA}" \
  --wait --log

exec env --ignore-environment /bin/bash
