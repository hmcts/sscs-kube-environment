#!/bin/bash
## Usage: ./local-credentials.sh
##
## Returns credentials

BASEDIR=$(dirname "$0")

#1. Login and obtain access token
USER_RESPONSE=$($BASEDIR/user-details.sh "${IDAM_SSCS_SYSTEMUPDATE_USER}" "${IDAM_SSCS_SYSTEMUPDATE_PASSWORD}")

S2S_TOKEN=$($BASEDIR/actions/idam-service-token.sh "wa_task_management_api")

echo  $USER_RESPONSE
echo  "s2s token:" $S2S_TOKEN
