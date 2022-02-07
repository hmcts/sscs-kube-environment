#!/bin/bash

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "ℹ️  Setting up Local development environment"
#echo "↪️️  Switching context to minikube"
#Switch to local cluster to avoid attempting to deploy in other clusters
#kubectl config use-context microk8s

echo "↪️️  Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "↪️  Creating persistent volume"
kubectl apply -f ./charts/pv.yaml -n $NAMESPACE
echo "↪️  Creating persistent volume claim"
kubectl apply -f ./charts/pvc.yaml -n $NAMESPACE

echo "↪️  Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml -n $NAMESPACE

echo "↪️  Obtaining ACR token"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "↪️  Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "↪️  Starting deployments"
helmfile -n $NAMESPACE sync  #Add to PATH or provide full path here

