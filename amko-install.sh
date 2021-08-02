#!/bin/bash

# Generating AMKO Config
echo Installing AMKO using Helm..
echo
echo Creating avi-system namespace
if ! kubectl get namespaces -o json | jq -r ".items[].metadata.name" | grep avi-system;then
  kubectl create ns avi-system
  echo Creating namespace avi-system successful
else
  echo Namespace avi-system exists
fi

# Checking gslb-members file and install gslb-members secret
if [ -e gslb-members ]
then
    kubectl create secret generic gslb-config-secret --from-file gslb-members -n avi-system
else
    echo gslb-members file is missing, please provide gslb-members file
    exit 0
fi
