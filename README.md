# SSCS Work Allocation Dev Environment

A Kubernetes environment with all the necessary services for local development using helm charts and deployed with
helmfile.

## Prerequisites

- HMCTS account
- Github access to public and private repositories. Need to have a Jira ticket (Reporting Mgr/Tech Lead will handle)
  Once the ticket got assigned, DevOps team will ask for user acceptance which can be done on this page
  https://tools.hmcts.net/confluence/display/RPE/Acceptable+Use+Policy+and+Contractor+Security+Guidance
- Access to Azure and container registry, clone https://github.com/hmcts/devops-azure-ad
  If you can't access it, then you do not have access to private repositories(Goto previous step) and check with Devops
  team. If you can access, then create a branch something like 'adding-permissions-your-name'.

Modify file /users/prod_users.yml by adding permissions to the EOF. Check with the team which permissions need to be
included.

Create a pull request and assign to a reviewer from the team and get approved. Post the pull request in slack channel
HMCTS Reform #devops request channel to authorise your pull request. Once it is approved a pipeline will be triggered
automatically.

- [k3s](https://k3s.io/) (See below for instructions to install on WSL2)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [azure-cli](https://docs.microsoft.com/en-gb/cli/azure/install-azure-cli)
  After installation, check if you can access Azure, by ```az login``` in your terminal. Page will open in your browser
  where you are prompted to log in to Microsoft using your hmcts email account. Click and log in. On your terminal you
  should see a list of accounts which have got permission. You can also type ```az account list``` to get the list of
  accounts you are subscribed to.
- [docker](https://www.docker.com/)
- [Helm](https://helm.sh)
- [Helmfile](https://github.com/roboll/helmfile) Scroll down to the installation section, download the latest binary and place it on your path.

The above can all brew installed via `brew install`

## Quick start
### k3s prerequisites
:warning: Ensure you change the the path to daemonize in /usr/sbin/enter-systemd-namespace to /usr/bin/daemonize (around line 10):warning:
WSL2 does not start with systemd which is required for some packages and k3s. There is a workaround to enable this, though:
[setup-systemd-on-WSL2](https://forum.snapcraft.io/t/running-snaps-on-wsl2-insiders-only-for-now/13033). You can ignore the optional steps.
### 1. Create a local cluster:

Latest Tested k3s version `v1.22.5+k3s1`

After installing k3s you should have a cluster setup, k3s creates its own kube config file under /etc/rancher/k3s/k3s.yaml. For ease of use it's recommended to copy over the cluster, context and user info into kubectl's kube config under ~/.kube/config. To achieve this you might need to add read permissions for others to the file. (chmod o+r k3s.yaml, copy, then chmod o-r k3s.yaml).

You should now be able to use kubectl config use-context default to have kubectl talk to your new cluster. Kubectl get --all-namespaces all should show a few resources in the kube-system namespace.

### 2. Environment variables

Ensure that you have filled out the paths at the bottom of the .env file. AZURE_SERVICE_BUS_CONNECTION_STRING also needs to be updated, the values can be found in Azure service bus. Also make sure your that you TASK_MANAGEMENT_API_URL variable is pointing to your current WSL IP.

Source the .env file in the root of the project:
```shell
source .env
```

Set the following environment variables on your `.bash_profile` and make sure the terminal can read `.bash_profile`. Secrets can be found in Azure key vault. For the Nexus details ask PlatOps.

```
export WA_CAMUNDA_NEXUS_PASSWORD=XXXXXX
export WA_CAMUNDA_NEXUS_USER=XXXXXX
export AM_ROLE_SERVICE_SDK_KEY=XXXXX
export LAUNCH_DARKLY_SDK_KEY=XXXXX
```

**Note:** _the values for the above environment variables can be found on
this [Confluence Page](https://tools.hmcts.net/confluence/display/WA/Camunda+Enterprise+Licence+Key)_. If you cannot
access the page, check with one of the team members.

### 3. Login:

```shell
./environment login
```

### 4. Pre-pulling (Recommended but optional):

*Note: this step could take a while to complete as it pull all the necessary images*


```shell
./environment pull
```

If you get an error regarding authentication when attempting to pull the images like: 

  ```
  Attempting to pull HMCTS public image from hmctspublic.azurecr.io/am/role-assignment-service:latest
  Error response from daemon: Head https://hmctspublic.azurecr.io/v2/am/role-assignment-service/manifests/latest: unauthorized: authentication required  
  ```

Then it is likely because an authentication token has expired. To fix it simply run:
```shell
docker logout hmctspublic.azurecr.io
```

### 5. Build and start local WA environment:
:warning: Either ensure helmfile is on your PATH or fill in the binary's path at the bottom of up.sh
Elastic search requires a higher vm.max_map_count. Increase with sudo sysctl -w vm.max_map_count=262144, add to bashprofile or similar.
```shell
./environment up
```

##### 1. Verify the deployment

We can verify the deployments were successful listing all pods under our namespace

    `kubectl get pods -n hmcts-local`

The output should look like below:

   ```
   ❯  kubectl get pods -n hmcts-local                                                                                10:57:13
   NAME                                         READY   STATUS    RESTARTS   AGE
   ccd-api-gateway-7f658885b9-gjg59             1/1     Running   0          2m5s
   ccd-case-management-web-7bc9987747-4fzhw     1/1     Running   0          114s
   ccd-data-store-api-7678c9c4cc-z8bwf          1/1     Running   0          2m40s
   ccd-definition-store-api-74b455764b-zdbgj    1/1     Running   0          3m48s
   ccd-orchestrator-65ffd6747c-s9w77            1/1     Running   0          101s
   ccd-shared-database-0                        1/1     Running   0          6m46s
   ccd-user-profile-api-749dd8d668-4b8cd        1/1     Running   0          5m49s
   fr-am-6b69cb5f95-2tlz4                       1/1     Running   0          5m25s
   fr-idm-575d89f957-fb6rl                      1/1     Running   0          5m22s
   idam-web-admin-957474868-l62q6               1/1     Running   0          4m34s
   idam-web-public-c8cf99759-s86g4              1/1     Running   0          4m15s
   service-auth-provider-api-5744c5f89b-9rtm5   1/1     Running   0          6m2s
   shared-db-76d8954d5c-24t2g                   1/1     Running   0          5m28s
   sidam-api-59b66bf4cb-d24j6                   1/1     Running   0          5m19s
   wiremock-59669584fc-xcxjw                    1/1     Running   0          74s
   xui-webapp-7485d8c499-htmq5                  1/1     Running   0          71s
   ```

:warning: ###Under construction :warning:

Wiremock has been left as is for now, if your xui-webapp still shows as not ready simply comment out the healthcheck section in xui-webapp.yaml.gotmpl.

You might get an ImagePullError for am-role assignment service - this is because we are using a temporary image whilst we wait to be onboarded with role assignment. If this happens, head over to Azure Container registry, within am/role-assignment-service try to locate the latest image tag for pr-1096 - if one does not exist simply head over to Jenkins and build the pull request.

##### 2. Import SSCS users, roles and definitions

As this repo is still under construction  users, roles and CCD definitions are imported from SSCS-docker. However, there are still some extra roles that need to be created, hence after importing from SSCS-docker, run setup.sh. To import from SSCS-docker you need to point the shell at the kube environment. Export these commands in the SSCS-docker shell:

```shell
export IDAM_STUB_LOCALHOST=http://sidam-simulator
export IDAM_API_BASE_URI=http://sidam-simulator
export CCD_DEFINITION_URL=http://ccd-definition-store-api
export SERIVE_AUTH_PROVIDER_URL=http://service-auth-provider-api
```

Then run:
```shell
./bin/create-simulator-users.sh # To create SSCS users
./bin/add-sscs-ccd-roles.sh # To add SSCS roles
./bin/ccd-import-definition.sh <Path to definition file> # to upload a CCD definition file
```

```shell
./scripts/setup.sh
```

### 6. Access services:

To access any of the service, Ingress should be enabled

##### 1. Update Ubuntu /etc/hosts to route the service names to Ubuntu localhost (translates to k3s cluster loadbalancer)

```shell
echo "127.0.0.1 ccd-shared-database service-auth-provider-api ccd-user-profile-api shared-db ccd-definition-store-api idam-web-admin ccd-definition-store-api ccd-data-store-api ccd-api-gateway wiremock xui-webapp camunda-local-bpm am-role-assignment sidam-simulator local-dm-store ccd-case-document-am-api" | sudo tee -a /etc/hosts
```
Example result:
127.0.0.1 xui-webapp sidam-simulator
127.0.0.1 ccd-shared-database service-auth-provider-api ccd-user-profile-api
127.0.0.1 shared-db ccd-definition-store-api idam-web-admin ccd-definition-store-api
127.0.0.1 ccd-data-store-api ccd-api-gateway wiremock
127.0.0.1 camunda-local-bpm am-role-assignment local-dm-store
127.0.0.1 ccd-case-document-am-api ccd-elasticsearch

To access any service type
`http://<name-of-service>`

For example:

`http://xui-webapp`

### 7. To stop and teardown local WA environment:

If you need to stop and teardown run cmd

```shell
./environment down
```
The above script deletes the ACR secret, destroys the helm deployments, the namespace, and finally, the persistent volume. 
You can run any of the commands in isolation as required.

### 8. Useful commands
To sync changes to the Helm charts (changes in the chart yaml, gotmpl or referenced environment variables within):

```shell
helmfile -n hmcts-local sync 
```

To scale all deployments in a namespace:
Change --replicas=x to 0 to bring all pods down, 1 to bring up one of each pod.

```shell
kubectl get -n hmcts-local deployments | awk '/^s|c|a/ {print $1}' | xargs kubectl scale -n hmcts-local --replicas=1 deployment
```
### 9. Known issues
- Persistence of users and roles - SIDAM simulator holds these in memory- you need to reimport these whenever the pod goes down.
- Changing WSL IPs: Windows Hosts needs to be updated with the new WSL ip address on every restart - important if you wish to navigate to the UI or execute commands
  from Windows. Use ifconfig or similar to get the IP address.
- Ubuntu names need to point to 127.0.0.1 in /etc/hosts. These can reset themselves between restarts, check these if hosts cannot be resolved.
- Postgres needs to be port forwarded for services to connect, in a new shell:
```shell
kubectl port-forward --namespace hmcts-local svc/ccd-shared-database 5432:5432 & PGPASSWORD="$POSTGRES_PASSWORD" psql --host 127.0.0.1 -U postgres -d ccd -p 5432
```
- Elastic search requires a higher vm.max_map_count. Increase with sudo sysctl -w vm.max_map_count=262144, add to     
  bashprofile or similar.        

### CCD message publishing to Azure Service Bus

The ccd message publishing app is a service that periodically checks the ccd database for unpublished messgaes and
publishes those messages to an azure service bus topic.

If you need to enable the ccd-message-publishing add the AZURE_SERVICE_BUS_CONNECTION_STRING variable and value on
your `.bash_profile` and resource the file before running environment up. For development the demo service bus details
are in Azure Service bus.

```shell
export AZURE_SERVICE_BUS_CONNECTION_STRING="Endpoint=sb://REPLACE_ME.servicebus.windows.net/;SharedAccessKeyName=REPLACE_ME;SharedAccessKey=REPLACE_ME"
```
