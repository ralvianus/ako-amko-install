#!/bin/bash

# Reading input
read -p 'AKO Version: ' ako_version

# Install Prerequisite
if ! command -v helm &> /dev/null
then
  echo Installing Helm..
  mkdir ~/helm-install
  cd ~/helm-install
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
  chmod 700 get_helm.sh
  ./get_helm.sh -v v3.0.3
  echo
  helm version
  echo
else
  echo Helm is already exists
fi

# Download requirements
if ! command -v jq &> /dev/null
then
  if [ -f /etc/redhat-release ]; then
    yum install jq -y
  fi

  if [ -f /etc/lsb-release ]; then
    apt-get install jq -y
  fi
  echo ====================================
else
  echo Requirements are met
fi

# Generating AKO Config
echo Installing AKO using Helm..
echo
if ! kubectl get namespaces -o json | jq -r ".items[].metadata.name" | grep avi-system;then
  echo Creating avi-system namespace
  kubectl create ns avi-system
  echo Creating namespace avi-system successful
else
  echo Namespace avi-system exists
fi

echo Adding AKO Repository..
helm repo add ako https://projects.registry.vmware.com/chartrepo/ako
echo Generating values.yaml file..
helm show values ako/ako --version $ako_version > ~/ako-amko-install/base-value/ako-values.yaml
