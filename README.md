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