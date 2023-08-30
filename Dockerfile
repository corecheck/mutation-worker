FROM ubuntu:22.04

# run curl healthcheck every 5 seconds
HEALTHCHECK --interval=5s --timeout=3s CMD curl -X POST ${HEALTHCHECK_WEBHOOK} -H "Content-Type: application/json" -d '{"text":"Bitcoin coverage build is running"}' || exit 1

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y git python3-zmq libevent-dev libboost-dev libdb5.3++-dev libsqlite3-dev libminiupnpc-dev libzmq3-dev libtool autotools-dev automake pkg-config bsdmainutils bsdextrautils curl wget lsb-release software-properties-common build-essential jq
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt update && apt install google-cloud-cli -y

RUN git config --global user.email "bitcoin-coverage@aureleoules.com"
RUN git config --global user.name "bitcoin-coverage"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]