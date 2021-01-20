#!/usr/bin/env bash

###
# usage: ./detokenize.sh "@TOKEN@" "replacement-val" "kubernetes/metaphor"
###

set -ex

TOKEN=$1
REPLACEMENT_VALUE=$2
K8S_DIR=$3

sed -i "s|${TOKEN}|${REPLACEMENT_VALUE}|g" "${K8S_DIR}"/*
