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


#!/bin/bash

SSH_PATH=${HOME}/gcp_keys
SSH_PUB_FILE=${SSH_PATH}/id_rsa.pub
SSH_USER=cloudbuild
REGION=europe-west1
ZONE=europe-west1-b
OKD_VERSION=release-3.11
LOG_PATH="${HOME}/okd/logs"
LOG_FILE="${LOG_PATH}/create-okd-logs-$(date +'%Y-%m-%d-%H:%M:%S')"
DELETE_LOG_FILE="${LOG_PATH}/delete-okd-logs-$(date +'%Y-%m-%d-%H:%M:%S')"
ORG_ID=615056687435
BILLING_ACCOUNT=0090FE-ED3D81-AF8E3B
CONTACT=avinashjha@google.com
