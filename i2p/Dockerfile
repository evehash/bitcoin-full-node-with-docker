FROM alpine:3.23 AS build

ARG I2P_VERSION

# Install build dependencies only in the builder stage.
RUN apk add --no-cache \
      apache-ant \
      gettext \
      git

WORKDIR /opt

# Clone the upstream release tag before building.
RUN git clone \
      --depth 1 \
      --branch "i2p-${I2P_VERSION}" \
      https://github.com/i2p/i2p.i2p.git \
      "i2p-${I2P_VERSION}"

# FIXME: Re-enable tag verification once the upstream I2P release signing keys are valid.
# The current developer keys used for release tags are expired, so this is intentionally
# left disabled in the same spirit as the BTC RPC Explorer commit pinning workaround.
# RUN cd i2p-${I2P_VERSION} \
#   && git verify-tag "i2p-${I2P_VERSION}"

# Build the Linux package layout copied into the runtime image.
RUN cd i2p-${I2P_VERSION} \
  && ant preppkg-linux-only


FROM alpine:3.23

ARG I2P_USER_ID
ARG I2P_VERSION
ARG GROUP_ID

ENV I2P_DIR_BASE="/i2p"
ENV I2P_DIR_CONFIG="/i2p/.i2p"
ENV I2PSNARK_DIR="/i2psnark"
ENV EEPSITE_DIR="/i2p/.i2p/eepsite"

COPY --from=build /opt/i2p-${I2P_VERSION}/pkg-temp /i2p
COPY --from=build /opt/i2p-${I2P_VERSION}/docker/rootfs/ /

# Install the Java runtime needed by I2P and run it as an unprivileged user.
RUN apk add --no-cache iproute2 openjdk21-jre-headless runuser shadow \
  && addgroup --gid ${GROUP_ID} i2p \
  && adduser -u ${I2P_USER_ID} --disabled-password --gecos "" --ingroup i2p i2p \
  && chown -R i2p:i2p /i2p /home/i2p \
  && chmod +x /entrypoint/entrypoint.sh

WORKDIR /i2p

CMD ["/entrypoint/entrypoint.sh"
