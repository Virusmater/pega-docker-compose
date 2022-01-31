# pega-docker-compose
Docker-compose files that will help you install Pega environment for your development, non-production needs. For production ready setup based on k8s please follow instructions prodived by Pegasystems: [pega-helm-charts](https://github.com/pegasystems/pega-helm-charts)

## common
Run `$ docker-compose up -d` to start containers that are shared between all Pega containers:
* NGINX Reverse Proxy (swag)
* Constellation UI
* Adminer
* Pega Deployment Manager Orchestrator with database

### NGINX Reverse Proxy (swag)
Taking care of certifications and subdomain routing. Configure environment variables in yaml file. Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`

More info ([here](https://docs.linuxserver.io/general/swag))

### Constellation UI
Update `CONSTELLATION_RUN_IMAGE` variable in `.env` file to image from Pegasystems ([how to get an image](https://docs.pega.com/user-experience-cosmos-react/87/installing-constellation-using-docker))

### Adminer
Doesn't require much configuration, all database connections are stored on the client side.

### Pega Deployment Manager Orchestrator
Not really required, but nice to play with. Feel free to remove it from the setup.

Update `POSTGRES_PASSWORD`, `ADMIN_PASSWORD`, `PEGA_INSTALL_IMAGE`, `PEGA_RUN_IMAGE` variable in `.env` ([how to build an install image]( https://github.com/pegasystems/pega-helm-charts/blob/master/docs/building-your-own-Pega-installer-image.md))
In order to install Pega Platform for Pega Deployment Manager run `$ docker-compose run pdm-install`

You will have to manually install Pega Deployment Manager Orchestrator itself from marketplace.

## pega[version]
Contains:
* postgresql databases for web and CDH nodes
* installer for web and CDH nodes ([how to build an install image]( https://github.com/pegasystems/pega-helm-charts/blob/master/docs/building-your-own-Pega-installer-image.md))
* web and CDH nodes
* cassandra for CDH
