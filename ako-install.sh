#!/bin/bash

# Reading input
read -p 'AKO Version: ' ako_version

# Install Prerequisite
echo Installing Helm..
mkdir ~/helm-install
cd ~/helm-install
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
echo
helm version
echo

# Download requirements
if [ -f /etc/redhat-release ]; then
  yum install jq -y
fi

if [ -f /etc/lsb-release ]; then
  apt-get install jq -y
fi
echo ====================================

# Install AKO
echo Installing AKO using Helm..
mkdir ako
cd ako
echo Creating directory successful
echo
echo Creating avi-system namespace
if ! kubectl get namespaces -o json | jq -r ".items[].metadata.name" | grep avi-system;then
  kubectl create ns avi-system
  echo Creating namespace avi-system successful
else
  echo Namespace avi-system exists
fi

echo Adding AKO Repository..
helm repo add ako https://projects.registry.vmware.com/chartrepo/ako
echo Generating values.yaml file..
helm show values ako/ako --version $ako_version > value-base/ako-values.yaml
cp value-base/ako-values.yaml ako-values.yaml
