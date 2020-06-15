#!/bin/bash

#
# PHPMyAdmin for Warden
#

envname="$(cat .env | grep "WARDEN_ENV_NAME" | cut -d '=' -f2)"
dbcontainer="${envname}_db_1"
echo "Connecting to $dbcontainer"
docker run --name wardenmyadmin \
           --hostname wardenmyadmin-warden \
           --rm \
           -eMYSQL_USER=magento \
           -eMYSQL_PASSWORD=magento \
           -ePMA_HOST=db \
           --link $dbcontainer:db \
           --network="warden" \
           --label "traefik.enable=true" \
           --label "traefik.http.routers.wardenmyadmin.tls=true" \
           --label "traefik.http.routers.wardenmyadmin.rule=Host(\"wardenmyadmin.warden.test\")" \
           --label "traefik.http.services.wardenmyadmin.loadbalancer.server.port=80" \
           phpmyadmin/phpmyadmin
