#!/bin/bash

set -e

if [ -e "/root/is_not_first_time" ]; then
	
	exec "$@"
else
	/usr/local/bin/docker-entrypoint.sh rabbitmq-server -detached

	rabbitmqctl -n "$RABBITMQ_NODENAME@$RABBITMQ_HOSTNAME" stop_app
	rabbitmqctl -n "$RABBITMQ_NODENAME@$RABBITMQ_HOSTNAME" join_cluster ${RMQHA_RAM_NODE:+--ram} "$RMQHA_MASTER_NODE@$RMQHA_MASTER_HOST"
	rabbitmqctl -n "$RABBITMQ_NODENAME@$RABBITMQ_HOSTNAME" start_app

	rabbitmqctl stop
	touch /root/is_not_first_time
	sleep 2s
	exec "$@"
fi