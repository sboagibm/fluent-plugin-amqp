#!/usr/bin/env bash

set -xe

rabbitmq-plugins enable rabbitmq_management --offline
rabbitmq-plugins enable rabbitmq_tracing --offline
service rabbitmq-server start

rabbitmqctl add_user admin password
rabbitmqctl set_user_tags admin administrator
rabbitmqctl set_permissions admin ".*" ".*" ".*"


## Create Queue
# curl -i -u admin:password -H "content-type:application/json" \
#        -XPUT -d'{"auto_delete":false,"durable":true}' \
#        http://localhost:15672/api/queues/%2f/logs

## Create hostkey and run ssh if needed.
# yum install -y openssh-server
# service sshd start

CONFIG=${1:-fluentd.conf}
td-agent -c /fluent-plugin-amqp/test/fixtures/${CONFIG}

## To debug
#/bin/bash
