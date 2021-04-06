FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt update
RUN apt upgrade -y

# Install key tools
RUN apt -y install \
  wget curl git vim sed ca-certificates \
  apt-transport-https lsb-release gnupg \
  software-properties-common openssl \
  apt-utils sudo

# Install ZSH
RUN apt -y install zsh

# Add User
RUN apt -y install openssl
ARG username="user"
ARG password="ThisIsNotAPaswword!"
RUN useradd -m -d /home/$username -p $(openssl passwd -1 $password) $username -s /usr/bin/zsh
RUN usermod -aG sudo $username

# Install OhMyZsh
RUN runuser -l $username -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'
RUN apt autoremove -y ; apt clean -y ; rm -rf /var/lib/apt/lists/*

# .NET 5 install
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb

RUN apt update; apt install -y apt-transport-https
RUN apt install -y dotnet-sdk-5.0

## Install Azure Cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Bicep install
RUN az bicep install
RUN mv /root/.azure/bin/bicep /usr/local/bin/bicep

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Install GH cli
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
RUN apt-add-repository https://cli.github.com/packages
RUN apt update
RUN apt install gh -y

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt update && apt -y install terraform

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -y | sh

# Install Golang
RUN wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
RUN export PATH=$PATH:/usr/local/go/bin

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt install -y nodejs

# Set default user
RUN echo "[user]\ndefault=$username" >> /etc/wsl.conf