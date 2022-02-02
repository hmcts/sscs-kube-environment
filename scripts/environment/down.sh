#!/bin/bash

NAMESPACE="sscs"
SECRET_NAME="hmcts-private-creds"

echo "💣  Deleting ACR token"
kubectl delete secret $SECRET_NAME -n $NAMESPACE

echo "💣  Stopping and removing all containers"
/home/dattipoe/helmfile/helmfile -n $NAMESPACE  --file destroy ####here too
