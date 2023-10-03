# pega-docker-compose
Docker-compose files that will help you install Pega environment for your development, non-production needs. For production ready setup based on k8s please follow instructions prodived by Pegasystems: [pega-helm-charts](https://github.com/pegasystems/pega-helm-charts)

## Building images
Following images are required to proceed:
* Pega Install - `PEGA_INSTALL_IMAGE`  ([how to build an install image]( https://github.com/pegasystems/pega-helm-charts/blob/master/docs/building-your-own-Pega-installer-image.md))
* Pega - `PEGA_RUN_IMAGE` (publicly available on docker hub)
* Constellation UI - `CONSTELLATION_RUN_IMAGE` ([how to get an image](https://docs.pega.com/user-experience-cosmos-react/87/installing-constellation-using-docker))

## Step-by-step guide
### Make DNS records for domain and subdomains:
* constellation`[version]`.`[domain]`
* pega`[version]`-web.`[domain]`
* pega`[version]`-cdh.`[domain]` (if need CDH)
* pdm.`[domain]` (if need PDM)

### SSH to the server and clone repo:
```
# git clone https://github.com/Virusmater/pega-docker-compose.git
```
### Setup Docker & Docker Compose
https://docs.docker.com/engine/install/

https://docs.docker.com/compose/install/

Login into your docker registry, e.g Docker Hub, where you have Pega and Constellation Images.

```# docker login```
### Install common part
1. `cd pega-docker-compose/common/`
2. Edit `.env`
   * Set `CONSTELLATION_RUN_IMAGE_[version]` to the image from Pega that was pushed to private repo
3. Edit `docker-compose.yml`
   * Change `URL` to your domain name
   * Change `EMAIL` to your email
   * Change `SUBDOMAINS` to subdomains you created DNS records for, e.g `pega87-web,pega87-cdh,constellation87,pdm`

4. Run `$ docker-compose up -d`
5. Check `$ docker logs swag -f` to see if there any errors
6. `$ cp *.conf appdata/swag/nginx/proxy-confs`
7. `$ docker restart swag`


### Install Basic Pega
1. `cd pega-docker-compose/pega[version]/`
2. Edit `.env`. Password with special characters were breaking installation, so try without them.
    * POSTGRES_PASSWORD=SomeGeneratedPassword
    * ADMIN_PASSWORD=SomeGeneratedPassword
    * PEGA_INSTALL_IMAGE=ImageYouBuildAndPushed
3. `# docker-compose run pega87-web-install`. It will take around 20-30 minutes.
4. `# docker-compose up -d`
5. `$ cp *.conf ../common/appdata/swag/nginx/proxy-confs`
6. `$ docker restart swag`
7. Login using administrator@pega.com with password from `.env`
8. Import KafkaDSS.zip
9. Update `ConstellationSvcURL` DSS to `https://constellation[version].[domain]/prweb/constellation`
10. `$ docker restart pega[version]-web`
11. Clean cache and cookies just to be sure


## Common
Before anything update enviromental variables in `.env` file.

Run `$ docker-compose up -d` to start containers that are shared between all Pega containers:
* NGINX Reverse Proxy (swag)
* Constellation UI
* Adminer
* Kafka with Zookeper

### NGINX Reverse Proxy (swag)
Taking care of certifications and subdomain routing. Configure environment variables in yaml file. Copy `*.conf` files to `common/appdata/swag/nginx/proxy-confs/`:
```
cp common/*.conf common/appdata/swag/nginx/proxy-confs
```

More info ([here](https://docs.linuxserver.io/general/swag))

### Constellation UI
Update `CONSTELLATION_RUN_IMAGE` variable in `.env`. Update `ConstellationSvcURL` DSS on taget applications with URL to it. 

### Adminer
Doesn't require much configuration, all database connections are stored on the client side.

## Pega`[version]`
Before anything update environment variables in `.env` file.`

Contains:
* Installer for Web and CDH instances 
* Web and CDH instances
* Cassandra

### Installer for Web and CDH instances
Before the first run Pega should be installed to the databases by running 

```
$ docker-compose run pega[version]-web-install
$ docker-compose --profile cdh run pega[version]-cdh-install

```

### Web and CDH instances
Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`:

```
cp pega[version]/*.conf common/appdata/swag/nginx/proxy-confs
```

Run `$ docker-compose up -d` to start Web instance.

Run `$ docker-compose --profile cdh up -d` to start Web and CDH instances.


Do not forget to update DSSs for Kafka, Constellation, ExternalMKTData.

You will have to manually install Pega CDH itself from marketplace.

### Cassandra
Parameters to connect to Cassandra are automatically passed to CDH instance. No need for an additional configuration.

## Pega Deployment Manager Orchestrator (PDM)

Not really required, but nice to play with.

Copy `*.subdomain.conf` files to `common/appdata/swag/nginx/proxy-confs/`

```
cp pega-pdm/*.conf common/appdata/swag/nginx/proxy-confs
```

In order to install Pega Platform for Pega Deployment Manager run `$ docker-compose run pdm-install`

Then just run `$ docker-compose up -d`

You will have to manually install Pega Deployment Manager Orchestrator itself from marketplace.
