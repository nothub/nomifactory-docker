FROM debian:12-slim

ARG NOMI_VER="1.6.1a"
ARG NOMI_URL="https://github.com/Nomi-CEu/Nomi-CEu/releases/download/${NOMI_VER}/nomi-ceu-${NOMI_VER}-server.zip"
ARG NOMI_SHA="f871c7c43ed3103ce8cd991d9f0cf96d7feb4c564a299463a7d4a0c91d8da885"

ADD "${NOMI_URL}" /tmp/server.zip
RUN echo "${NOMI_SHA} /tmp/server.zip" | sha256sum -c -

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update                             \
 && apt-get upgrade -y --with-new-pkgs         \
 && apt-get install -y --no-install-recommends \
    apt-transport-https                        \
    ca-certificates                            \
    curl                                       \
    tini                                       \
    unzip

RUN mkdir -p /etc/apt/keyrings \
 && curl -fsSL -o /etc/apt/keyrings/adoptium.asc "https://packages.adoptium.net/artifactory/api/gpg/key/public" \
 && echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb bookworm main" \
  | tee /etc/apt/sources.list.d/adoptium.list

RUN apt-get update                             \
 && apt-get install -y --no-install-recommends \
    temurin-8-jdk                              \
 && apt-get clean -y                           \
 && apt-get autoremove -y                      \
 && rm -rf /var/lib/apt/lists/*

RUN unzip /tmp/server.zip -d /opt/server \
 && rm -f /tmp/server.zip                \
 && chown -R 1000:1000 /opt/server

ENV MEM_MIN="2048M"
ENV MEM_MAX="2048M"

EXPOSE 25565/tcp

USER 1000:1000

CMD ["tini", "-v", "--", "java", "-server", "-Xms${MEM_MIN}", "-Xmx${MEM_MAX}", "-Dlog4j.configurationFile=log4j2_112-116.xml", "-jar", "forge-1.12.2-14.23.5.2860.jar", "nogui"]
