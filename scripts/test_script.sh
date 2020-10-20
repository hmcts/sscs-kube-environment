#!/bin/sh
IMPORTER_USERNAME=${1:-ccd-import@fake.hmcts.net}
IMPORTER_PASSWORD=${2:-London01}
IDAM_OPEN_ID_URI=http://sidam-api/o/token
REDIRECT_URI="http://localhost:4096/oauth2redirect"
CLIENT_ID="ccd_gateway"
CLIENT_SECRET="OOOOOOOOOOOOOOOO"
GRANT_TYPE="password"
SCOPE_VARIABLES=openid%20profile%20roles%20authorities
curl ${CURL_OPTS} -H "Content-Type: application/x-www-form-urlencoded" -XPOST "${IDAM_OPEN_ID_URI}?client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}&grant_type=${GRANT_TYPE}&scope=${SCOPE_VARIABLES}&username=${IMPORTER_USERNAME}&password=${IMPORTER_PASSWORD}" -d "" | jq -r .access_token
