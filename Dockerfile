FROM jenkins/jenkins:lts

# Switch to root user to install .NET SDK
USER root

# Show distro information!
RUN uname -a && cat /etc/*release

# Install all dependencies for .NET Core, Powershell & Docker
RUN apt-get update
RUN apt-get install -y \
    curl libunwind8 gettext apt-transport-https gnupg

# Based on instructiions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install microsoft.qpg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'

# Install the .NET Core 3.1 & .NET 5.0 frameworks & powershell
RUN apt-get update
RUN apt-get install -y dotnet-sdk-3.1 dotnet-sdk-5.0 powershell

# Install Docker clinet
RUN apt-get update && \
    apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y install docker-ce

# RUN usermod -aG docker jenkins

# # Switch back to jenkins user
# USER jenkins