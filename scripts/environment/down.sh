#!/bin/bash

NAMESPACE="hmcts-local"
SECRET_NAME="hmcts-private-creds"

echo "💣  Deleting ACR token"
kubectl delete secret $SECRET_NAME -n $NAMESPACE

echo "💣  Stopping and removing all containers"
helmfile -n $NAMESPACE destroy

echo "💣  Deleting namespace"
kubectl delete ns $NAMESPACE

echo "💣  Deleting persistent volume"
kubectl delete pv shared-pv-volume