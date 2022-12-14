# Copyright 2021 Google LLC
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


#! /bin/bash

# Delete the cluster creation and deployment script 

set -e 
source $(dirname "$0")/variables.sh

## Generate SSH Key
function generate_ssh() {
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Generate SSH function starts ------------" >> ${LOG_FILE}
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Generate SSH function starts ------------"
if [ -f $SSH_PUB_FILE ] 
then
  echo "$(date +'%Y-%m-%d %H:%M:%S'): SSH Key is already present."  >> ${LOG_FILE}
else  
echo "$(date +'%Y-%m-%d %H:%M:%S'): Generating SSH keys $SSH_PATH "  >> ${LOG_FILE}
ssh-keygen -b 2048 -t rsa -f $SSH_PATH/id_rsa -q -N "" <<< y 
## ssh-keygen -b 2048 -t rsa -f $SSH_PATH/id_rsa -q -N "" <<< $'\ny' >/dev/null 2>&1
fi
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Generate SSH function Ends ------------" >> ${LOG_FILE}
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Generate SSH function Ends ------------" 
}

## Destroy BOA deployment on OKD cluster

function delete_manifest() {
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Delete Manifest function starts  ------------" >> ${DELETE_LOG_FILE}
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Delete Bank of anthos deployment ------------" >> ${DELETE_LOG_FILE}
cd ../terraform
terraform init
## PROJECT=$(terraform output project_id | tr -d '"')
MASTER=$(terraform output master | tr -d '"')
echo "$(date +'%Y-%m-%d %H:%M:%S'):SSH into the master node to delete manifest files" >> ${DELETE_LOG_FILE}

gcloud compute ssh --project=$PROJECT --zone=$ZONE $SSH_USER@$MASTER >> ${DELETE_LOG_FILE} << EOF
function delete_boa() {
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Deploy BOA function starts ------------"
oc delete -f bank-of-anthos/kubernetes-manifest/jwt/jwt-secret.yaml
oc delete -f bank-of-anthos/kubernetes-manifest/.
echo "############################################################"
echo "Waiting for  60 seconds for workloads to be removed..."
echo "############################################################"
sleep 60s
oc get pods
echo "$(date +'%Y-%m-%d %H:%M:%S'): Exiting from the master node."
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Delete BOA function Ends ------------"
} 
delete_boa
EOF
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- delete manifest function ends ------------" >> ${DELETE_LOG_FILE}
}


function delete_infra() {
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Delete Infra function starts ------------" >> ${DELETE_LOG_FILE}
cd ../terraform
terraform init
terraform destroy  -var="gce_ssh_pub_key_file=$SSH_PUB_FILE" -var="project_id"=$PROJECT  -auto-approve >> ${DELETE_LOG_FILE}
echo "$(date +'%Y-%m-%d %H:%M:%S'):-------- Delete Infra function Ends ------------" >> ${DELETE_LOG_FILE}
}
mkdir -p ${SSH_PATH}
mkdir -p ${LOG_PATH}
touch ${DELETE_LOG_FILE}


generate_ssh
##delete_manifest
delete_infra
