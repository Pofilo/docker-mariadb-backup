#!/bin/bash

NAME=mariadb-backup
# Get most recent tag
VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))

docker build -t registry.pofilo.fr/${NAME}:${VERSION} -t pofilo/${NAME}:${VERSION} .
docker push registry.pofilo.fr/${NAME}:${VERSION}
docker push pofilo/${NAME}:${VERSION}

