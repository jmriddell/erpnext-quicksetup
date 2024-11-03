# Simple single site ERPNext setup

This is a simple setup for a single site ERPNext installation. It uses the official Frappe docker repository and it's based on the Frappe documentation.

## Requirements

- Git
- Docker
- Docker Compose 2

## Installation

1. Clone this repository and `cd` into it.
2. Run ./setup.sh. This will clone the frappe_docker repo at the commit scpecified in `defaults.env`, create a directory called `gitops` where env files and a docker compose yml will be created.
3. Run ./create-site.sh. This will create a new site that will be served on the port specified in `defaults.env`, which currently is 8080 and it will be accessible using any host name. This will leave the services running in the background.

### Considerations

- This setup only provides the application exposed in port 8080. You have to provide the proper proxying, TLS, WAF and other services situable for your use case. A simple solution that can work for many cases is to use a Cloudflare Zero Trust tunnel and leave TLS, DNS management and DoS protection to Cloudflare (All available in the free tier).

- It's advisable that you are familiar with docker compose and the Frappe framework before using this setup and read the scripts before running them.

## Included tools/shortcuts

- `./compose` is a shortcut to `docker compose` with using the correct compose file, project name and environment file.
- `./bench` is a shortcut to `bench` inside the `backend` container for administrative tasks of the Frappe installation.

## Design decisions

- The `frappe_docker` repository is cloned at a specific commit to ensure that the setup is stable and tested. This is to avoid any breaking changes that might be introduced in the future.

- Git submodules are not used to keep the setup simple and easy to understand.

- DB root user and Frappe Administrator password are generated randomly and stored in the `gitops` directory. This is to prevent default password attacks.
