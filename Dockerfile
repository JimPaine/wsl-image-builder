FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt update && apt upgrade -y

# Install key tools
RUN apt -y install \
  wget curl git vim sed ca-certificates \
  apt-transport-https lsb-release gnupg \
  software-properties-common openssl \
  apt-utils sudo gcc unzip dnsutils

# Install ZSH
RUN apt -y install zsh

# Add User
ARG username="user"
ARG password="password"
RUN useradd -m -d /home/$username -p $(echo $password | openssl passwd -1 -stdin) $username -s /usr/bin/zsh
RUN usermod -aG sudo $username

# Install OhMyZsh
RUN runuser -l $username -c 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended'

# .NET 5 install
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN apt update && apt install -y dotnet-sdk-5.0

## Install Azure Cli
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
RUN AZ_REPO=$(lsb_release -cs) && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list
RUN sudo apt update
RUN apt install azure-cli

# Bicep install
RUN az bicep install

# mv .azure
RUN mv /root/.azure /home/$username/
RUN chown -R $username /home/$username/.azure
RUN export PATH=$PATH:/home/$username/.azure/bin

# Install kubectl
RUN curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

# Install GH cli
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
RUN apt-add-repository https://cli.github.com/packages
RUN apt update && apt -y install gh

# Install Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add -
RUN apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
RUN apt update && apt -y install terraform

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN mv /root/.cargo /home/$username/
RUN chown -R $username /home/$username/.cargo
RUN export PATH=$PATH:/home/$username/.cargo/bin
RUN runuser -l $username -c 'sh -c "$(rustup install stable)" "" --unattended'
RUN runuser -l $username -c 'sh -c "$(rustup default stable)" "" --unattended'

# Install Golang
RUN wget https://golang.org/dl/go1.16.2.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && tar -C /usr/local -xzf go1.16.2.linux-amd64.tar.gz
RUN rm -f go1.16.2.linux-amd64.tar.gz

# Install node
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | bash -
RUN apt install -y nodejs

# Configure DNS
RUN echo "\n[network]\ngenerateResolvConf=false" >> /etc/wsl.conf
CMD echo "nameserver 1.1.1.1" > /etc/resolv.conf

# Set default user
RUN echo "\n[user]\ndefault=$username" >> /etc/wsl.conf

# add exorts to user profile
RUN echo "export PATH=\$PATH:/usr/local/go/bin" >> /home/$username/.zshrc
RUN echo "export PATH=\$PATH:/home/$username/.cargo/bin" >> /home/$username/.zshrc
RUN echo "export PATH=\$PATH:/home/$username/.azure/bin" >> /home/$username/.zshrc
RUN echo "export PATH=\$PATH:/home/$username/.cargo/bin" >> /home/$username/.zshrc
RUN echo "export PATH=\$PATH:/home/$username/.azure/bin" >> /home/$username/.zshrc

# Clean up
RUN apt autoremove -y ; apt clean -y ; rm -rf /var/lib/apt/lists/*
RUN rm packages-microsoft-prod.deb -f
