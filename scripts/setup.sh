#!/usr/bin/env bash

# Setup Services
#./create-services.sh

# Setup Roles
#./create-roles.sh

# Register roles
#./register-roles.sh

#### Import users and roles from sscs-docker#######
# There's an org role assignment script in here that's required.
./create-users.sh

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
./wiremock.sh #Possibly not required for now

echo "Deploying camunda bpmn and dmn"
./camunda-deployment.sh
