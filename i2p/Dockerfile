FROM alpine:latest AS build
ARG I2P_VERSION
RUN apk add --update --no-cache apache-ant bzip2 gettext gpg gpg-agent wget \
  && cd /opt \
  && wget https://github.com/i2p/i2p.i2p/releases/download/i2p-${I2P_VERSION}/i2psource_${I2P_VERSION}.tar.bz2 \
  && wget https://github.com/i2p/i2p.i2p/releases/download/i2p-${I2P_VERSION}/i2psource_${I2P_VERSION}.tar.bz2.sig \
  && wget -O - https://geti2p.net/_static/idk.key.asc | gpg --import \
  && gpg --verify i2psource_${I2P_VERSION}.tar.bz2.sig \
  && tar -xvf i2psource_${I2P_VERSION}.tar.bz2 \
  && cd i2p-${I2P_VERSION} \
  && ant preppkg-linux-only \
  && apk del apache-ant bzip2 gettext gpg gpg-agent wget


FROM alpine:latest
ARG I2P_USER_ID
ARG I2P_VERSION
ARG GROUP_ID
COPY --from=build /opt/i2p-${I2P_VERSION}/pkg-temp /i2p
COPY --from=build /opt/i2p-${I2P_VERSION}/docker/rootfs/ /
RUN apk add --update --no-cache openjdk17-jre-headless \
  && addgroup --gid ${GROUP_ID} i2p \
  && adduser -u ${I2P_USER_ID} --disabled-password --gecos "" --ingroup i2p i2p \
  && chmod +x /startapp.sh

USER i2p

CMD /startapp.sh
