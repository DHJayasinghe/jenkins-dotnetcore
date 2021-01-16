FROM jenkins/jenkins:lts

# Switch to root user to install .NET SDK
USER root

# Show distro information!
RUN uname -a && cat /etc/*release

# Install all dependencies for .NET Core, Powershell & Docker
RUN apt-get update
RUN apt-get install -y \
    curl libunwind8 gettext apt-transport-https gnupg \
    software-properties-common gnupg2

# Based on instructiions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install microsoft.qpg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'

# Install the .NET Core 3.1 & .NET 5.0 frameworks & powershell
RUN apt-get update
RUN apt-get install -y dotnet-sdk-3.1 dotnet-sdk-5.0 powershell

# Based on instructiions at https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-debian-9
# Add Docker repository GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian stretch stable"

# Install Docker
RUN apt update
RUN apt install -y docker-ce

# Download Docker-compose binary & give executable permissions
RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# Switch back to jenkins user
USER jenkins
