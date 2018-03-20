# Docker GUI
This project offers multiple Dockerfile/docker-compose.yml pairs to create containers that can launch GUI application on the same display as the host using X11 sharing.

## How to start

- Launch the `create_container.sh <container_name> <non_root_user> <install_path>` with the following parameters:
  - container_name: the name folder containing the app you want to launch
  - non_root_user: a non root user that will be created, its home folder will contain a shared folder
  - install_path: the path to a folder that will contain the build content (Dockerfile, shared folder, ...)
  - Example: `create_container.sh ubuntu nichuguen ../install_ubuntu`
    - Creates a new `ubuntu` container.
    - The user `nichuguen` will be created and added to the sudoers
    - A new folder will be created in `../install_ubuntu`. This folder will contain everything needed to deploy new containers (`Dockerfile`, `docker-compose.yml`), as well as a `main/shared` folder, which is mounted into `$HOME/shared`.
  - Note: For now, the only three valid parameters for `container_name` are:
    1. `ubuntu`
    2. `kali`
    3. `hadoop1`, see the README file in the `hadoop1` folder
- Once this script has been run, the container is ready and started.
- Now you can launch GUI applications from your container's shell

## Troubleshooting
- If you see a "connection refused" error, you might have to use `xhost +` on the host computer so it accepts connections. (Needed for archlinux config)

## MacOS
`create_container.sh` will install brew and socat. Socat will run on port 6000.

If you have the following error :

```
socat[16168] E bind(5, {LEN=0 AF=2 0.0.0.0:6000}, 16): Address already in use
```

close XQuartz and start `create_container.sh` again.

## Warnings

Since the X11 is shared between the container and the host, the container has access to all the events fired in the host environment, including keypresses (so beware of what you're running).
