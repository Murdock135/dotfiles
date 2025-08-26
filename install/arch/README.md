# Usage

To install packages, run

```
chmod +x install_packages.sh
./install_packages.sh
```
[1](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Install_packages_from_a_list)

# Post-install steps (Docker-related)

After installation, you need to 

1. set up docker socket and engine by following the steps in [2](https://docs.docker.com/engine/install/linux-postinstall/)
2. connect your machine to docker hub with 

```
docker login
```

[3](https://docs.docker.com/reference/cli/docker/login/#authenticate-to-docker-hub-with-web-based-login)

# References

1. https://wiki.archlinux.org/title/Pacman/Tips_and_tricks#Install_packages_from_a_list
2. https://docs.docker.com/engine/install/linux-postinstall/
3. https://docs.docker.com/reference/cli/docker/login/#authenticate-to-docker-hub-with-web-based-login
