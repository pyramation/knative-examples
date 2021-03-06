#!/usr/bin/env bash

CHANNEL_NAME=seqofseq
CHANNEL_HOSTNAME=$(kubectl get sequence.messaging.knative.dev $CHANNEL_NAME -o=jsonpath='{.status.address.hostname}')

kubectl exec shell -- curl $CHANNEL_HOSTNAME \
  -X POST \
  -H 'Content-Type: application/json' \
  -H "CE-CloudEventsVersion: 0.1" \
  -H "CE-EventType: dev.knative.foo.bar" \
  -H "CE-EventTime: 2018-04-05T03:56:24Z" \
  -H "CE-EventID: 45a8b444-3213-4758-be3f-540bf93f85ff" \
  -H "CE-Source: dev.knative.example" \
  -d '{ "msg": "an event" }'



