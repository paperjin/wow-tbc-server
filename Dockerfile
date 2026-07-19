FROM docker.io/thoriumlxc/cmangos-tbc:bots-2025.05.11 AS builder

USER root
RUN rm -rf /var/lib/apt/lists/* && mkdir -p /var/lib/apt/lists/partial &&     apt-get update && apt-get install -y --no-install-recommends     build-essential cmake git ca-certificates     libboost-dev libboost-system-dev libboost-filesystem-dev     libboost-program-options-dev libboost-thread-dev     libboost-regex-dev     default-libmysqlclient-dev libssl-dev zlib1g-dev libicu-dev     && rm -rf /var/lib/apt/lists/*

COPY source/mangos-tbc /tmp/mangos-tbc
COPY source/playerbots /tmp/playerbots

RUN rm -rf /tmp/build && mkdir -p /tmp/build && cd /tmp/build &&     cmake /tmp/mangos-tbc -DCMAKE_INSTALL_PREFIX=/tmp/install     -DPCH=1 -DBUILD_PLAYERBOTS=ON -DPLAYERBOTS_SOURCE_DIR=/tmp/playerbots     -DDEBUG=0 &&     make -j4 mangosd

FROM docker.io/thoriumlxc/cmangos-tbc:bots-2025.05.11

USER root
RUN rm -rf /var/lib/apt/lists/* && mkdir -p /var/lib/apt/lists/partial &&     apt-get update && apt-get install -y --no-install-recommends     libmysqlclient21     && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/build/src/mangosd/mangosd /opt/mangos/bin/mangosd
COPY etc /opt/mangos/etc
WORKDIR /opt/mangos/bin
CMD [./mangosd]
