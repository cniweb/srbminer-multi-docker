FROM debian:trixie-slim

ARG VERSION_TAG=3.0.2
ENV ALGO="randomx"
ENV POOL_ADDRESS="stratum+ssl://rx.unmineable.com:443"
ENV WALLET_USER="ltc1q6c4vres6a390mtm4updr5jc6thyv22pu0dupq8"
# Note: Default password is set to "x" - override at runtime for production use
ENV PASSWORD="x"
ENV EXTRAS="--api-enable --api-port 80 --disable-auto-affinity --disable-gpu"

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl wget ca-certificates \
    && update-ca-certificates \
    && cd /opt \
    && VERSION_STRING=$(echo "$VERSION_TAG" | tr '.' '-') \
    && (curl -L https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/SRBMiner-Multi-${VERSION_STRING}-Linux.tar.gz -o SRBMiner-Multi.tar.gz || \
        wget --progress=dot:giga --no-check-certificate https://github.com/doktor83/SRBMiner-Multi/releases/download/${VERSION_TAG}/SRBMiner-Multi-${VERSION_STRING}-Linux.tar.gz -O SRBMiner-Multi.tar.gz) \
    && tar xf SRBMiner-Multi.tar.gz \
    && rm -rf SRBMiner-Multi.tar.gz \
    && mv /opt/SRBMiner-Multi-${VERSION_STRING}/ /opt/SRBMiner-Multi/ \
    && groupadd -r srbminer && useradd -r -g srbminer -d /opt/SRBMiner-Multi -s /bin/bash srbminer \
    && chown -R srbminer:srbminer /opt/SRBMiner-Multi \
    && apt-get -y autoremove --purge \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /opt/SRBMiner-Multi/
COPY start_zergpool.sh .

RUN chmod +x start_zergpool.sh

# Switch to non-root user for security
USER srbminer

EXPOSE 80

ENTRYPOINT ["./start_zergpool.sh"]
CMD ["--api-enable", "--api-port", "80", "--disable-auto-affinity", "--disable-gpu"]
