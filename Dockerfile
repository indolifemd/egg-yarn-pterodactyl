FROM node:20-bullseye
ARG IMAGE_VERSION
ARG IMAGE_REVISION
ARG IMAGE_CREATED
LABEL author="IndoLife" \
      org.opencontainers.image.version="${IMAGE_VERSION}" \
      org.opencontainers.image.revision="${IMAGE_REVISION}" \
      org.opencontainers.image.created="${IMAGE_CREATED}"

RUN apt update && apt -y install \
        ffmpeg \
        iproute2 \
        git \
        sqlite3 \
        libsqlite3-dev \
        python3 \
        python3-dev \
        ca-certificates \
        dnsutils \
        tzdata \
        zip \
        tar \
        curl \
        build-essential \
        libtool \
        iputils-ping \
        libatk-bridge2.0-0 \
        libatk1.0-0 \
        libcups2 \
        libdrm2 \
        libxcomposite1 \
        libxdamage1 \
        libxrandr2 \
        libgbm1 \
        libasound2 \
        libpangocairo-1.0-0 \
        libpango-1.0-0 \
        libx11-xcb1 \
        libxcb1 \
        libxext6 \
        libxfixes3 \
        libnss3 \
        libx11-6 \
        libxrender1 \
        libjpeg62-turbo \
        libgtk-3-0 \
        fonts-liberation \
        libappindicator3-1 \
        lsb-release \
        xdg-utils \
        wget \
        ca-certificates \
        && apt-get clean \
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
