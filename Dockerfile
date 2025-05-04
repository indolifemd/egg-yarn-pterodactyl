FROM node:20-bullseye
ARG IMAGE_VERSION
ARG IMAGE_REVISION
ARG IMAGE_CREATED
LABEL author="IndoLife" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.created="${IMAGE_CREATED}"

RUN apt update && apt install -y \
    git \
    curl \
    ca-certificates \
    lsb-release \
    xdg-utils \
    iproute2 \
    python3 \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

#Yarn via Corepack
RUN corepack enable && corepack prepare yarn@stable --activate

# Tambah user non-root
RUN useradd -m -d /home/container container

USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]
