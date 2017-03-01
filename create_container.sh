#! /bin/bash
set -e
set -u

function check_arguments
{
    if [ "$#" != "2" ]
    then
        cat << EOF
Usage: $0 <container_folder> <user>
EOF
        exit 0
    fi
}

function create_container
{
    local readonly PATH_TO_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local readonly CONTAINER=$1
    local readonly USER_TO_CREATE=$2
    local readonly DEFAULT_USER=default_user

    pushd $PATH_TO_SCRIPT/$CONTAINER
    set +e # there can be an error if the script has already been run once and the user has been set to anything else than $DEFAULT_USER
    sed s/$DEFAULT_USER/$USER_TO_CREATE/ -i docker-compose.yml
    sed s/$DEFAULT_USER/$USER_TO_CREATE/ -i main/Dockerfile
    set -e
    docker-compose up --build
    popd
}

check_arguments "$@"
create_container "$@"
