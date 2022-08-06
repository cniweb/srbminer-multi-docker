FROM debian:stable-slim
RUN apt-get update && apt-get -y install wget xz-utils && \
    cd /opt && wget https://github.com/doktor83/SRBMiner-Multi/releases/download/1.0.4/SRBMiner-Multi-1-0-4-Linux.tar.xz && \
	tar xf SRBMiner-Multi-1-0-4-Linux.tar.xz && rm -rf /opt/SRBMiner-Multi-1-0-4-Linux.tar.xz && \
	apt-get -y purge xz-utils && apt-get -y autoremove --purge && apt-get -y clean && apt-get -y autoclean; rm -rf /var/lib/apt-get/lists/*
ENV ALGO="minotaurx"
ENV POOL_ADDRESS="stratum+tcp://minotaurx.na.mine.zergpool.com:7019"
ENV WALLET_USER="LNec6RpZxX6Q1EJYkKjUPBTohM7Ux6uMUy"
ENV PASSWORD="c=LTC,ID=docker"
ENV EXTRAS="--api-enable --api-port 80 --disable-gpu --cpu-threads 4"
EXPOSE 80
COPY start_zergpool.sh /opt/SRBMiner-Multi-1-0-4/
RUN chmod +x /opt/SRBMiner-Multi-1-0-4/start_zergpool.sh
WORKDIR "/opt/SRBMiner-Multi-1-0-4"
ENTRYPOINT ["./start_zergpool.sh"]