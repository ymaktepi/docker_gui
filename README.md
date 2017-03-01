# docker_gui
This project offers multiple Dockerfile/docker-compose.yml pairs to create containers that can launch GUI application on the same display as the host using X11 sharing.

## How start

- Launch the `create_container.sh` with the following parameters:
  - container_name: the folder containing the app you want to launch
  - non_root_user: a non root user that will be created, its home folder will contain a shared folder
- Once this script has been run, the container is ready and started. 

## Warnings

Since the X11 is shared between the container and the host, the container has access to all the events fired in the host environment.
