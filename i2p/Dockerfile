FROM debian:stable-slim AS build
ARG I2P_VERSION
RUN apt-get update \
  && apt-get install ant bzip2 gettext gpg wget -y \
  && cd /opt \
  && wget https://github.com/i2p/i2p.i2p/releases/download/i2p-${I2P_VERSION}/i2psource_${I2P_VERSION}.tar.bz2 \
  && wget https://github.com/i2p/i2p.i2p/releases/download/i2p-${I2P_VERSION}/i2psource_${I2P_VERSION}.tar.bz2.sig \
  && wget -O - https://geti2p.net/_static/idk.key.asc | gpg --import \
  && gpg --verify i2psource_${I2P_VERSION}.tar.bz2.sig \
  && tar -xvf i2psource_${I2P_VERSION}.tar.bz2 \
  && cd i2p-${I2P_VERSION} \
  && ant preppkg-linux-only \
  && rm -rf pkg-temp/osid pkg-temp/lib/wrapper pkg-temp/lib/wrapper.*


FROM debian:stable-slim
ARG I2P_USER_ID
ARG I2P_VERSION
ARG GROUP_ID
COPY --from=build /opt/i2p-${I2P_VERSION}/pkg-temp /i2p
COPY --from=build /opt/i2p-${I2P_VERSION}/docker/rootfs/ /
RUN apt-get update \
  && apt-get install openjdk-17-jre -y \
  && rm -rf /var/lib/apt/lists/* \
  && addgroup --gid ${GROUP_ID} i2p \
  && adduser -u ${I2P_USER_ID} --disabled-password --gecos "" --ingroup i2p i2p \
  && chmod +x /startapp.sh

USER root

CMD /startapp.sh
