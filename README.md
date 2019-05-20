# deploy

This repo will contain deploy tools for Contested Terrain.

# CT Wordpress deploy

Deployment for the CT wordpress instance(s) using terraform. Key components of terraform deploy:

* Each WP instance deploy is acheived with a terraform module located in `modules/wp`.
* Each modules instance is declared in the root terraform configuration `main.tf`.

The WP module uses a docker-compose stack configuration to setup the wp server, database, etc on each docker instance, see `docker/full-stack.yml`. The docker-compose configuration points to a docker image `ctwp-wp` built from the `Dockerfile`.

To deploy there are two steps required:

1. Create a file called `terraform.tfvars` in the `/ctwp` directory. In it, you need to define three values:

```
do_token="<digital-ocean-api-token>"
public_key_path="/path/to/public_key"
private_key_path="/path/to/private/key"
```

The digital ocean API token must be acquired through the digital ocean site or via their api. The public and priate key paths point to an ssh key.

Generate these key files with: `ssh-keygen -o -a 100 -t ssh-ed25519 -C ct@digitalocean`.

2. Once these variables are defined, you should be able to deploy the infrastructure using this simple command:

```
terraform apply
```

To destroy the infrastructure, do:

```
terraform destroy
```



