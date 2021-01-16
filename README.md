# jenkins-dotnetcore
Jenkins docker container with .NET Core 3.1, .NET Core 5 SDKs and Powershell installed. Docker compose environment contains RabbitMQ + MSSQL Server 2017 containers (with default configs) needed for Jenkins CI/CD environemnt.

Environment setup for plugins:
Poweshell - https://plugins.jenkins.io/powershell


## run environment
```console
docker-compose up -d
```