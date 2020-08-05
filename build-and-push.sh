#!/bin/bash

function scriptDone {
    echo "---> DONE"
    exit 0
}

function printLine {
    echo "------------------------------------------------------------------------------"
}

NAME=mariadb-backup


echo "---> Do you want to build the latest image of ${NAME}? [y/n]"
read answer
if [[ "${answer}" == "y" ]]; then
    docker build -t ${NAME}:latest .
    scriptDone
fi

# Get most recent tag
VERSION=$(git describe --tags $(git rev-list --tags --max-count=1))

printLine
echo "---> Do you want to build the ${VERSION} image of ${NAME}? [y/n]"
read answer
if [[ "${answer}" == "y" ]]; then
    docker build -t registry.pofilo.fr/${NAME}:${VERSION} -t pofilo/${NAME}:${VERSION} .
    ret=$?
    if [ ${ret} -ne 0 ]; then
        echo "Something went wrong .."
        exit 1
    fi
else
    scriptDone
fi

printLine
echo "---> Do you want to push the ${VERSION} image of ${NAME}? [y/n]"
read answer
if [[ "${answer}" == "y" ]]; then
    docker push registry.pofilo.fr/${NAME}:${VERSION}
    docker push pofilo/${NAME}:${VERSION}
fi

scriptDone

