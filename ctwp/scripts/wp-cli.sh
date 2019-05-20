#!/bin/bash

display_usage() {
    echo "Usage: $0 <wp-cli command w/out 'wp' part>."
}

DOCKER_CMD=$(which docker)

if [ "${*:1}" == "" ]; then
    display_usage
    exit 1
fi

echo "Finding wordpress docker container..."
WP_CONTAINER=$(docker container ls | grep ctwp_wp | cut -c 1-12)
echo "Found: $WP_CONTAINER"

$DOCKER_CMD run -it --rm \
            --volumes-from $WP_CONTAINER \
            --net container:$WP_CONTAINER \
            --name "wp-cli" \
            wordpress:cli "${@:1}"
