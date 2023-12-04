FROM alpine:3

ARG NOMI_VER="1.6.1a"
ARG NOMI_URL="https://github.com/Nomi-CEu/Nomi-CEu/releases/download/${NOMI_VER}/nomi-ceu-${NOMI_VER}-server.zip"
ARG NOMI_SHA="f871c7c43ed3103ce8cd991d9f0cf96d7feb4c564a299463a7d4a0c91d8da885"

RUN apk add --no-cache openjdk8-jre-base tini

ADD "${NOMI_URL}" /tmp/server.zip
RUN echo "${NOMI_SHA} /tmp/server.zip" | sha256sum -c -

RUN unzip /tmp/server.zip -d /opt/nomi \
 && rm -f /tmp/server.zip              \
 && chown -R 1000:1000 /opt/nomi

WORKDIR /opt/nomi

ENV MEMORY="4G"

EXPOSE 25565/tcp

USER 1000:1000

CMD ["sh", "-c", "tini -v -- java -server -Xms${MEMORY} -Xmx${MEMORY} -Dlog4j.configurationFile=log4j2_112-116.xml -jar forge-1.12.2-14.23.5.2860.jar nogui"]
