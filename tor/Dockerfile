FROM alpine:3.23 AS build

ARG TOR_VERSION

RUN apk add --no-cache \
      autoconf \
      automake \
      build-base \
      ca-certificates \
      curl \
      git \
      gnupg \
      libevent-dev \
      libevent-static \
      linux-headers \
      openssl-dev \
      openssl-libs-static \
      zlib-dev \
      zlib-static \
      zstd-dev \
      zstd-static

WORKDIR /tmp

RUN git clone \
      --depth 1 \
      --branch "tor-${TOR_VERSION}" \
      https://gitlab.torproject.org/tpo/core/tor.git

WORKDIR /tmp/tor

RUN curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/1C1BC007A9F607AA8152C040BEA7B180B1491921 | gpg --batch --import \
  && curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36 | gpg --batch --import \
  && curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/2133BC600AB133E1D826D173FE43009C4607B1FB | gpg --batch --import \
  && git verify-tag "tor-${TOR_VERSION}"

RUN ./autogen.sh \
  && ./configure \
      --disable-asciidoc \
      --disable-unittests \
      --enable-static-libevent \
      --enable-static-openssl \
      --enable-static-tor \
      --enable-static-zlib \
      --sysconfdir=/etc \
      --with-libevent-dir=/usr \
      --with-openssl-dir=/usr \
      --with-zlib-dir=/usr \
      LIBS="-lzstd -lz" \
  && make -j"$(nproc)" \
  && strip src/app/tor \
  && cp src/app/tor /tmp/tor-bin


FROM alpine:3.23

ARG TOR_USER_ID=1000
ARG GROUP_ID=1000

COPY --from=build /tmp/tor-bin /usr/local/bin/tor

RUN addgroup -g "${GROUP_ID}" tor \
  && adduser -u "${TOR_USER_ID}" -D -G tor -h /home/tor tor \
  && mkdir -p /home/tor/.tor \
  && chown -R tor:tor /home/tor

USER tor
WORKDIR /home/tor

ENTRYPOINT ["/usr/local/bin/tor"]
CMD ["-f", "/home/tor/torrc.default"]
