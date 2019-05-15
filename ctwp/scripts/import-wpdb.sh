#!/bin/bash

display_usage() {
    echo "Usage: $0 <name-of-sql-file>."
    echo "Note: SQL file must be placed in directory /data, accessible from call dir."
}

DOCKER_CMD=$(which docker)

if [ "$1" == "" ]; then
    display_usage
    exit 1
fi

DB_FILE=$1

echo "Finding wordpress docker container..."
WP_CONTAINER=$(docker container ls | grep ctwp_wp | cut -c 1-12)
echo "Found: $WP_CONTAINER"

# echo "Copying db file into container..."
# docker cp $DB_FILE "$WP_CONTAINER:$DB_FILE"

$DOCKER_CMD run -it --rm \
        --volume "$(pwd)/data:/data" \
        --volumes-from $WP_CONTAINER \
        --net container:$WP_CONTAINER \
        --name "wp-cli" \
        wordpress:cli db import "/data/$DB_FILE"

