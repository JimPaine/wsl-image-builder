# WSL image builder

## Run in either PowerShell or an existing WSL image

> if running in WSL ensure the output is located somewhere on /mnt/c/ such as `/mnt/c/users/user/image.tar`

```
docker run --name {name} ghcr.io/jimpaine/wsl-image-builder:{release version}

docker export --output image.tar {name}
```

## In PowerShell

> `{directory}` is the location you want the virtual disk stored.

```
wsl --import {name} {directory} image.tar
```

# What's out the box

## OS
 - Ubuntu 20.04

## Shells
- bash
- sh
- zsh (with ohmyzsh)

## Additional sudoers
- user

## Packages
- wget
- curl
- git
- vim
- sed
- ca-certificates
- apt-transport-https
- lsb-release
- gnupg
- software-properties-common
- openssl
- apt-utils
- sudo
- unzip

## Dev tools
- .NET 5
- Azure cli
- Bicep
- kubectl
- GH cli
- Terraform
- Rust
- Golang
- node

## WSL Config
- default user set to user
