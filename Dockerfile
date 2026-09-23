FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TERM=xterm-256color

# Installera grundverktyg, nano och nödvändiga Linux-beroenden för .NET runtime
RUN apt-get update && apt-get install -y \
    curl \
    git \
    nano \
    sudo \
    ca-certificates \
    libicu-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Installera .NET 10 SDK via Microsofts officiella installationsskript
ENV DOTNET_ROOT=/usr/share/dotnet
RUN curl -fsSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel 10.0 --install-dir /usr/share/dotnet \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Skapa en icke-root användare
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Skapa en icke-root användare och konfigurera arbetskataloger
RUN useradd -m -s /bin/bash developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    mkdir -p /home/developer/.gemini && \
    chown -R developer:developer /home/developer

USER developer
WORKDIR /home/developer

# Installera Antigravity CLI
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash

ENV PATH="/home/developer/.local/bin:${PATH}"

WORKDIR /workspace
ENTRYPOINT ["agy"]