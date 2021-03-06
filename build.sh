#!/usr/bin/env bash

baseDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source ${baseDir}/.env

function __docker_recipe() {
    ${baseDir}/../docker-recipes/docker-recipe "${@}"
}

if [[ ! -d ${baseDir}/log ]]; then
    mkdir ${baseDir}/log
fi

if [[ ! -z "$1" ]]; then
    buildOrder=($1)
fi

for tag in ${buildOrder[*]}; do
    logFile="${baseDir}/log/${tag}.log"
    :>$logFile

    cd ${baseDir}/${tag}

    [[ -f Dockerfile.recipe ]] && __docker_recipe

    imageName=pretzlaw/php:${tag}
    docker build --no-cache -t ${imageName} . 2>&1 | tee ${baseDir}/log/php_${tag}.log
    echo ""
done

ls *.err 2>/dev/null
