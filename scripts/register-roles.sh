#!/usr/bin/env bash

echo ""
echo "Registering roles in CCD..."

USER_TOKEN="$(sh ./actions/idam-user-token.sh)"
SERVICE_TOKEN="$(sh ./actions/idam-service-token.sh)"

#Remains because of xui whitelisting.
./actions/register-role.sh "caseworker-ia-caseofficer" "$USER_TOKEN" "$SERVICE_TOKEN" ###Only ia roles whitelisted in xui TribunalsCaseworkerGuard

./actions/register-role.sh "caseworker-ras-validation" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-caa" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-approver" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "citizen" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "pui-case-manager" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "pui-user-manager" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "pui-finance-manager" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "pui-organisation-manager" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "caseworker-sscs" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "caseworker-sscs-dwpresponsewriter" "$USER_TOKEN" "$SERVICE_TOKEN"

./actions/register-role.sh "payments" "$USER_TOKEN" "$SERVICE_TOKEN"

# Roles required for Notice of Change
./actions/register-role.sh "caseworker-approver" "$USER_TOKEN" "$SERVICE_TOKEN"
./actions/register-role.sh "prd-aac-system" "$USER_TOKEN" "$SERVICE_TOKEN"

echo ""
echo "Registering CCD Roles has completed"
