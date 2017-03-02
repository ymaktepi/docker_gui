#! /bin/bash
set -e
set -u

function check_arguments
{
  if [ "$#" != "3" ]
  then
    cat << EOF
Usage: $0 <container_folder> <user> <install_folder>
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
  local readonly PATH_TO_CONTAINER_INPUT=$PATH_TO_SCRIPT/$CONTAINER
  local readonly PATH_TO_CONTAINER_OUTPUT=$3

  mkdir -p $PATH_TO_CONTAINER_OUTPUT

  cp -r $PATH_TO_CONTAINER_INPUT/* $PATH_TO_CONTAINER_OUTPUT

  pushd $PATH_TO_CONTAINER_OUTPUT
  set +e # there can be an error if the script has already been run once and the user has been set to anything else than $DEFAULT_USER

  # if MacOS
  if [ "$(uname)" == "Darwin" ]; then
    sed -i '' s/DISPLAY=$\{DISPLAY\}/DISPLAY="$(ipconfig getifaddr en1)":0/ docker-compose.yml

    # check if Brew is installed
    which -s brew
    if [[ $? != 0 ]] ; then
      # Install Homebrew
      ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
      echo "Brew is already installed"
    fi

    # install socat
    if brew ls --versions socat > /dev/null; then
      echo "socat is already installed"
    else
      brew install socat
    fi

    sed -i '' s/$DEFAULT_USER/$USER_TO_CREATE/ docker-compose.yml
    sed -i '' s/$DEFAULT_USER/$USER_TO_CREATE/ main/Dockerfile

    socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    sleep 5
  else
    sed s/$DEFAULT_USER/$USER_TO_CREATE/ -i docker-compose.yml
    sed s/$DEFAULT_USER/$USER_TO_CREATE/ -i main/Dockerfile
  fi

  set -e
  docker-compose up --build
  popd
}

check_arguments "$@"
create_container "$@"
