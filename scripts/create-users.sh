#!/usr/bin/env bash

# Setup Users
echo ""
echo "Setting up SSCS Users and role assignments..."

##XUI only has IA whitelisted, perhaps AM. Causing issues with retrieving role assignments.
./actions/organisational-role-assignment.sh "${CASE_WORKER_USER}" "${CASE_WORKER_PASSWORD}" "PUBLIC" "senior-tribunal-caseworker" '{"jurisdiction":"SSCS","primaryLocation":"765324"}'
./actions/organisational-role-assignment.sh "${CASE_WORKER_USER}" "${CASE_WORKER_PASSWORD}" "PUBLIC" "senior-tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'