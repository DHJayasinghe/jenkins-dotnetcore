FROM jenkins/jenkins:lts

# Switch to root user to install .NET SDK
USER root

# Show distro information!
RUN uname -a && cat /etc/*release

# Based on instructiions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install dependency for .NET Core 2
RUN apt-get update
RUN apt-get install -y curl libunwind8 gettext apt-transport-https gnupg

# Based on instructions at https://www.microsoft.com/net/download/linux-package-manager/debian9/sdk-current
# Install microsoft.qpg
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
RUN mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/dotnetdev.list'

# Install the .NET Core framework
RUN apt-get update
RUN apt-get install -y dotnet-sdk-5.0

# Based on instructions at https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7.1#debian-9
# Import the public repository GPG keys & Register the Microsoft Product feed
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-debian-stretch-prod stretch main" > /etc/apt/sources.list.d/microsoft.list'

#  Enable the "universe" repositories & Install PowerShell
RUN apt-get update
RUN apt-get install -y powershell

# Switch back to jenkins user
USER jenkins
