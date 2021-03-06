#!/usr/bin/env bash

# Copyright 2019 IBM Corporation
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

ROOT=$(dirname $BASH_SOURCE[0])/../..
source $ROOT/hack/lib/library.sh
NS=examples-broker
k8s::create_and_set_ns $NS

u::testsuite "Broker-Trigger"

cd $ROOT/examples/broker

u::header "Deploying..."

kubectl label namespace $NS knative-eventing-injection=enabled
sleep 5

kubectl describe deployments default-broker-filter

kubectl apply -f config
k8s::wait_until_pods_running $NS
sleep 5

kubectl apply -f dummy-ksvc.yaml

k8s::wait_log_contains "serving.knative.dev/configuration=event-display" user-container dev.knative.apiserver.ref.add
k8s::wait_log_contains "serving.knative.dev/configuration=event-display" user-container Revision

kubectl describe ksvc dummy
kubectl describe apiserversources revision

u::header "cleanup"
kubectl delete -f config
k8s::delete_ns $NS
