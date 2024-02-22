#!/bin/bash

# set -x

## Install rancher cli
wget -q https://releases.rancher.com/cli2/v2.8.0/rancher-linux-amd64-v2.8.0.tar.gz && \
tar -zxvf rancher-linux-amd64-v2.8.0.tar.gz &> /dev/null && \
sudo mv rancher-v2.8.0/rancher /usr/local/bin/ && \
[[ "$?" == "0" ]] && echo "Install rancher cli ok"
sudo rm -rf rancher-linux-amd64-v2.8.0.tar.gz rancher-v2.8.0/

## Login Rancher
[[ -z "$1" ]] && echo "\$1 is API Token" && exit 1
rancher login https://192.168.61.153 --skip-verify -t $1 &> /dev/null
[[ "$?" == "0" ]] && echo "Login Rancher ok"

## Create a new K8S Configuration and mark it for import
rancher cluster create talos --import
sleep 5

## Import Talos Kubernetes Cluster into Rancher
bash -c "$(rancher cluster import talos -q | tail -1)" &> /dev/null

## Check Rancher pods status
watch -n 1 kubectl -n cattle-system get pods
