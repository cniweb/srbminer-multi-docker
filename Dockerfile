FROM debian:stable-slim

ENV ALGO="minotaurx"
ENV POOL_ADDRESS="stratum+tcp://minotaurx.na.mine.zergpool.com:7019"
ENV WALLET_USER="LNec6RpZxX6Q1EJYkKjUPBTohM7Ux6uMUy"
ENV PASSWORD="c=LTC,ID=docker"
ENV EXTRAS="--api-enable --api-port 80 --disable-auto-affinity --disable-gpu"

RUN apt-get update && apt-get -y install wget xz-utils && \
    cd /opt && \
    wget https://github.com/doktor83/SRBMiner-Multi/releases/download/2.3.0/SRBMiner-Multi-2-3-0-Linux.tar.xz -O SRBMiner-Multi.tar.xz && \
    tar xf SRBMiner-Multi.tar.xz && \
    rm -rf /opt/SRBMiner-Multi.tar.xz && \
    mv /opt/SRBMiner-Multi-2-3-0/ /opt/SRBMiner-Multi/ && \
    apt-get -y purge xz-utils && \
    apt-get -y autoremove --purge && \
    apt-get -y clean && \
    apt-get -y autoclean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/SRBMiner-Multi/
COPY start_zergpool.sh .

RUN chmod +x start_zergpool.sh

EXPOSE 80

ENTRYPOINT ["./start_zergpool.sh"]
CMD ["--api-enable", "--api-port", "80", "--disable-auto-affinity", "--disable-gpu"]
