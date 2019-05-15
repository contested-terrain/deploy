# deploy

This repo will contain deploy tools for Contested Terrain.

# CT Wordpress deploy

Deployment for the CT wordpress instance(s) using terraform. Key components of terraform deploy:

* Each WP instance deploy is acheived with a terraform module located in `modules/wp`.
* Each modules instance is declared in the root terraform configuration `main.tf`.

The WP module uses a docker-compose stack configuration to setup the wp server, database, etc on each docker instance, see `docker/full-stack.yml`. The docker-compose configuration points to a docker image `ctwp-wp` built from the `Dockerfile`.





