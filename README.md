# WSL image builder

## In PowerShell

> `{directory}` is the location you want the virtual disk stored.

```powershell
docker run --name {name} ghcr.io/jimpaine/wsl-image-builder:{release version}

docker export --output image.tar {name}

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
- dnsutils (nslookup, dig ...)
- iputils-ping
- net-tools

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
