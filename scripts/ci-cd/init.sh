#!/usr/bin/env bash

set -e

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# GIT SETUP
git config --global user.email "gitlab-bot@${CI_SERVER_HOST}"
git config --global user.name "gitlab-bot"
git config --global url."git@${CI_SERVER_HOST}:".insteadOf "https://${CI_SERVER_HOST}/"
git remote set-url origin "git@${CI_SERVER_HOST}:${CI_PROJECT_PATH}" 

# SSH ACCESS SETUP
eval $(ssh-agent -s)
echo "${GITLAB_BOT_SSH_PRIVATE_KEY}" | ssh-add -
mkdir -p ~/.ssh
echo -e "Host *\n\tStrictHostKeyChecking no\n\n" > ~/.ssh/config

# aws profile setup
mkdir -p ~/.aws
cat << EOF > ~/.aws/config
[default]
output = json
region = us-east-1
[profile preprod]
role_arn = arn:aws:iam::$AWS_ACCOUNT_ID:role/KubernetesAdmin
source_profile = default
EOF

cat << EOF > ~/.aws/credentials
[default]
aws_access_key_id = ${GITLAB_BOT_AWS_ACCESS_KEY_ID}
aws_secret_access_key = ${GITLAB_BOT_AWS_SECRET_ACCESS_KEY}
EOF
