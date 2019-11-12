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
ROOT=$(dirname $BASH_SOURCE[0])/..
source $ROOT/hack/lib/library.sh

docker login -p $DOCKER_PASS -u $DOCKER_USER docker.io

serving_version=$1
eventing_version=$2

u::header "Starting kind cluster"
. $ROOT/hack/setup-knative-kind.sh $1 $2

u::header "Installing dependencies"
$ROOT/hack/npm-install.sh

u::header "Testing..."
$ROOT/test/sequence.sh

if [[ $(semver::gte ${eventing_version} 0.9.0) ]]; then
    $ROOT/test/parallel.sh
fi

$ROOT/examples/apiserversource/test.sh
$ROOT/examples/functions/test.sh

if [[ $(semver::gte ${eventing_version} 0.10.0) ]]; then
    $ROOT/examples/helloretail/test.sh
fi

#$ROOT/examples/broker/test.sh