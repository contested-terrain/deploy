#!/usr/bin/env bash

set -e

echo "Sleeping for 30 seconds so WP can spin up..."
sleep 30

chmod u+x ./wp-cli.sh

./wp-cli.sh core install
