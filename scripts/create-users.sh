#!/usr/bin/env bash

# Setup Users
echo ""
echo "Setting up required Users..."
./actions/create-user.sh "ccd-import@fake.hmcts.net" "CCD" "Import" "London01" "ccd-import" "[{\"code\":\"ccd-import\"}]"
./actions/create-user.sh "${IA_SYSTEM_USERNAME}" "System" "user" "${IA_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}]"

echo "Setting up WA test accounts"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_A_USERNAME}" "CaseOfficer" "TestPurposes A" "${TEST_WA_CASEOFFICER_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/create-user.sh "${TEST_WA_CASEOFFICER_B_USERNAME}" "CaseOfficer" "TestPurposes B" "${TEST_WA_CASEOFFICER_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/create-user.sh "${TEST_WA_LAW_FIRM_USERNAME}" "LegalRep" "TestPurposes" "${TEST_WA_LAW_FIRM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}, { \"code\": \"caseworker-ia-legalrep-solicitor\"}, { \"code\": \"payments\"}]"

echo "Setting up WA Users and role assignments..."
./actions/create-user.sh "${WA_SYSTEM_USERNAME}" "WASystem" "WaUser" "${WA_SYSTEM_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-system\"}, { \"code\": \"caseworker-wa\"}, { \"code\": \"caseworker-wa-task-configuration\"}]"

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "CaseOfficer" "A-Public" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_A_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_A_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "CaseOfficer" "B-Public" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_B_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_B_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","region":"east-england","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "CaseOfficer" "C-Public" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_C_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_C_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","primaryLocation":"765324"}'

./actions/create-user.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "CaseOfficer" "D-Public" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-ia\"}, { \"code\": \"caseworker-ia-caseofficer\"}]"
./actions/organisational-role-assignment.sh "${TEST_WA_CASEOFFICER_PUBLIC_D_USERNAME}" "${TEST_WA_CASEOFFICER_PUBLIC_D_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"IA","region":"east-england","primaryLocation":"765324"}'

echo "Setting up SSCS Users and role assignments..."
./actions/create-user.sh "${IDAM_SSCS_SYSTEMUPDATE_USER}" "SSCSSystem" "SSCSUser" "${IDAM_SSCS_SYSTEMUPDATE_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-sscs\"}, { \"code\": \"caseworker-sscs-systemupdate\"}]"

./actions/create-user.sh "${CASE_WORKER_USER}" "CaseOfficer" "A-Public" "${CASE_WORKER_PASSWORD}" "caseworker" "[{ \"code\": \"caseworker\"}, { \"code\": \"caseworker-sscs\"}, { \"code\": \"caseworker-sscs-tcw\"}]"
./actions/organisational-role-assignment.sh "${CASE_WORKER_USER}" "${CASE_WORKER_PASSWORD}" "PUBLIC" "tribunal-caseworker" '{"jurisdiction":"SSCS","primaryLocation":"765324"}'
