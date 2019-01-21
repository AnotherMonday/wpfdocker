FROM microsoft/dotnet-framework:4.7.2-runtime-windowsservercore-ltsc2016

LABEL vendor="Another Monday" \
      maintainer="michael victore <michael.victore@anothermonday.com>" \
      description="Dotnet Framework 4.7.2 with Nunit and DocFx" \
      version="1.0.0"

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install DocFx CLI
ENV DOCFX_VERSION 2.40.7
RUN New-Item -Type Directory $env:ProgramFiles\DocFx; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Uri "https://github.com/dotnet/docfx/releases/download/v${env:DOCFX_VERSION}/docfx.zip" -OutFile docfx.zip; \
    Expand-Archive docfx.zip -DestinationPath $env:ProgramFiles\docfx\; \
    Remove-Item -Force docfx.zip

# Install NUnit CLI
ENV NUNIT_VERSION 3.9
ENV NUNIT_BUG_VERSION 0
RUN New-Item -Type Directory $env:ProgramFiles\NUnit; \
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
    Invoke-WebRequest -Uri "https://github.com/nunit/nunit-console/releases/download/v${env:NUNIT_VERSION}/NUnit.Console-${env:NUNIT_VERSION}.${env:NUNIT_VERSION}.zip" -OutFile NUnit.Console.zip; \
    Expand-Archive NUnit.Console.zip -DestinationPath $env:ProgramFiles\NUnit\; \
    Remove-Item -Force NUnit.Console.zip

# Set PATH in one layer to keep image size down.
RUN setx /M PATH $(${env:PATH} \
    + \";${env:ProgramFiles}\NUnit\" \
    + \";${env:ProgramFiles}\DocFx\")