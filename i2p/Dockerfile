FROM alpine:3.23 AS build

ARG I2P_VERSION

# Install build dependencies only in the builder stage.
RUN apk add --no-cache \
      apache-ant \
      curl \
      gettext \
      git \
      gpg \
      gpg-agent

WORKDIR /opt

# Import I2P release signing keys before verifying the upstream release tag.
RUN curl -fsSL https://i2p.net/zzz.key.asc | gpg --batch --import \
  && curl -fsSL https://i2p.net/idk.key.asc | gpg --batch --import \
  && gpgconf --kill all

# Clone and verify the upstream release tag before building.
RUN git clone \
      --depth 1 \
      --branch "i2p-${I2P_VERSION}" \
      https://github.com/i2p/i2p.i2p.git \
      "i2p-${I2P_VERSION}" \
  && cd "i2p-${I2P_VERSION}" \
  && git verify-tag "i2p-${I2P_VERSION}"

# Build the Linux package layout copied into the runtime image.
RUN cd i2p-${I2P_VERSION} \
  && ant preppkg-linux-only


FROM alpine:3.23

ARG I2P_USER_ID
ARG I2P_VERSION
ARG GROUP_ID

COPY --from=build /opt/i2p-${I2P_VERSION}/pkg-temp /i2p
COPY --from=build /opt/i2p-${I2P_VERSION}/docker/rootfs/ /

# Install the Java runtime needed by I2P and run it as an unprivileged user.
RUN apk add --no-cache openjdk17-jre-headless \
  && addgroup --gid ${GROUP_ID} i2p \
  && adduser -u ${I2P_USER_ID} --disabled-password --gecos "" --ingroup i2p i2p \
  && chown -R i2p:i2p /i2p /home/i2p \
  && chmod +x /startapp.sh

WORKDIR /i2p
USER i2p

CMD ["/startapp.sh"]
