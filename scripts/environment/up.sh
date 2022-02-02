#!/bin/bash

NAMESPACE="sscs"
SECRET_NAME="hmcts-private-creds"

echo "ℹ️  Setting up Local development environment"
#echo "↪️️  Switching context to minikube"
#Switch to local cluster to avoid attempting to deploy in other clusters
#kubectl config use-context microk8s

echo "↪️️  Creating $NAMESPACE namespace"
#This might error if namespace already exist, but will not stop the script.
kubectl create namespace $NAMESPACE

echo "↪️  Creating persistent volume"
kubectl apply -f ./charts/pv.yaml -n sscs
echo "↪️  Creating persistent volume claim"
kubectl apply -f ./charts/pvc.yaml -n sscs

echo "↪️  Applying ingress config"
kubectl apply -f ./ingress/ingress.yaml -n sscs
#kubectl patch configmap nginx-ingress-tcp-microk8s-conf -n ingress --patch '{"data":{"5432":"hmcts-local/ccd-shared-database:5432"}}'
#manually patch daemonset
#microk8s.kubectl patch configmap nginx-ingress-tcp-microk8s-conf --patch '{"data":{"5432":"hmcts-local/ccd-shared-database:5432"}}'-n ingress

echo "↪️  Obtaining ACR token"
TOKEN=$(az acr login --name hmctsprivate --subscription DCD-CNP-PROD --expose-token | jq --raw-output '.accessToken')

echo "↪️  Saving Token as secret"
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=hmctsprivate.azurecr.io \
  --docker-username=00000000-0000-0000-0000-000000000000 \
  --docker-password=$TOKEN \
  -n $NAMESPACE

echo "↪️  Starting deployments"
/home/dattipoe/helmfile/helmfile -n sscs sync  #Add to path


 #k3d cluster create local --port 9001:80@loadbalancer"
 #volume mounts? change code on the fly?
 #proper config file