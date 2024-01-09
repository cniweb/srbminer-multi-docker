FROM debian:stable-slim

ENV ALGO="yespoweric"
ENV POOL_ADDRESS="stratum+tcp://yespowerIC.na.mine.zergpool.com:6238"
ENV WALLET_USER="LNec6RpZxX6Q1EJYkKjUPBTohM7Ux6uMUy"
ENV PASSWORD="c=LTC,ID=docker"
ENV EXTRAS="--api-enable --api-port 80 --disable-auto-affinity --disable-gpu"

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl xz-utils \
    && cd /opt \
    && curl -L https://github.com/doktor83/SRBMiner-Multi/releases/download/2.4.5/SRBMiner-Multi-2-4-5-Linux.tar.xz -o SRBMiner-Multi.tar.xz \
    && tar xf SRBMiner-Multi.tar.xz \
    && rm -rf SRBMiner-Multi.tar.xz \
    && mv /opt/SRBMiner-Multi-2-4-5/ /opt/SRBMiner-Multi/ \
    && apt-get -y purge xz-utils \
    && apt-get -y autoremove --purge \
    && apt-get -y clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

WORKDIR /opt/SRBMiner-Multi/
COPY start_zergpool.sh .

RUN chmod +x start_zergpool.sh

EXPOSE 80

ENTRYPOINT ["./start_zergpool.sh"]
CMD ["--api-enable", "--api-port", "80", "--disable-auto-affinity", "--disable-gpu"]
