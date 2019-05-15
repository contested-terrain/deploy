#!/bin/bash

openssl rand -base64 12 | docker secret create ctwp_db_password -

