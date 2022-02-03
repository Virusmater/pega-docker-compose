# pega-docker-compose
Docker-compose files that will help you install Pega environment for your development, non-production needs. For production ready setup based on k8s please follow instructions prodived by Pegasystems: [pega-helm-charts](https://github.com/pegasystems/pega-helm-charts)

## Building images
Following images are required to proceed:
* Pega Install - `PEGA_INSTALL_IMAGE`  ([how to build an install image]( https://github.com/pegasystems/pega-helm-charts/blob/master/docs/building-your-own-Pega-installer-image.md))
* Pega - `PEGA_RUN_IMAGE` (publicly available on docker hub)
* Constellation UI - `CONSTELLATION_RUN_IMAGE` ([how to get an image](https://docs.pega.com/user-experience-cosmos-react/87/installing-constellation-using-docker))


## Common
Before anything update enviromental variables in `.env` file.

Run `$ docker-compose up -d` to start containers that are shared between all Pega containers:
* NGINX Reverse Proxy (swag)
* Constellation UI
* Adminer
* Kafka with Zookeper

### NGINX Reverse Proxy (swag)
Taking care of certifications and subdomain routing. Configure environment variables in yaml file. Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`

More info ([here](https://docs.linuxserver.io/general/swag))

### Constellation UI
Update `CONSTELLATION_RUN_IMAGE` variable in `.env`. Update `ConstellationSvcURL` DSS on taget applications with URL to it. 

### Adminer
Doesn't require much configuration, all database connections are stored on the client side.

### Kafka with Zookeper
Starting Pega 8.7 it is deprecated to have nodes of type Stream. External Kafka services has to be used instead.

In order to connect to the common container of Kafka create following DSS with Pega-Engine owning ruleset:
* prconfig/services/stream/provider/default with value "ExternalKafka"
* prconfig/services/stream/**broker**/url/default with value "kafka:29092". Note that documentation provided by Pega is wrong and setting should be for **broker** instead **provider**
* prconfig/services/stream/name/pattern/default with value "pega-*cluster_name*-{stream.name}". Change *cluster_name* to the unique name of your Pega cluster


## Pega`[version]`
Before anything update enviromental variables in `.env` file.`

Contains:
* Installer for Web and CDH instances 
* Web and CDH instances
* Cassandra

### Installer for Web and CDH instances
Before the first run Pega should be installed to the databases by running 

```$ docker-compose run pega[version]-web-install pega[version]-cdh-install```

### Web and CDH instances
Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`

Run `$ docker-compose up -d` to start Web and CDH instances.

Do not forget to update DSSs for Kafka, Constellation, ExternalMKTData.

You will have to manually install Pega CDH itself from marketplace.

### Cassandra
Parameters to connect to Cassandra are automatically passed to CDH instance. No need for an additional configuration.

## Pega Deployment Manager Orchestartor (PDM)

Not really required, but nice to play with.

Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`

In order to install Pega Platform for Pega Deployment Manager run `$ docker-compose run pdm-install`

Then just run `$ docker-compose up -d`

You will have to manually install Pega Deployment Manager Orchestrator itself from marketplace.
