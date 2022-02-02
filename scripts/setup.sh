#!/usr/bin/env bash

# Setup Services
#./create-services.sh

# Setup Roles
#./create-roles.sh

# Setup Users
#./create-users.sh

# Register roles
#./register-roles.sh

#### Import users and roles from sscs-docker#######

echo ""
echo "Setup Wiremock responses for Professional Reference Data based on existing Idam users..."
./wiremock.sh #Possibly not required for now

echo "Deploying camunda bpmn and dmn"
./camunda-deployment.sh
