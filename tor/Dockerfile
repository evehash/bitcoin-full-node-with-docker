FROM debian:stable-slim AS build
ARG TOR_VERSION

RUN apt-get update \
  && apt-get install --no-install-recommends -y autoconf automake build-essential ca-certificates curl git gpg gpg-agent libevent-dev libssl-dev libzstd-dev zlib1g-dev \
  && mkdir /tmp/gpg-keys && cd /tmp/gpg-keys \
  # One or many of these keys can sign the releases. Verificable in https://gitlab.torproject.org/dgoulet/tor
  && curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/1C1BC007A9F607AA8152C040BEA7B180B1491921 > key1.gpg \
  && curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/B74417EDDF22AC9F9E90F49142E86A2A11F48D36 > key2.gpg \
  && curl -fsSL https://keys.openpgp.org/vks/v1/by-fingerprint/2133BC600AB133E1D826D173FE43009C4607B1FB > key3.gpg \
  && gpg --import key1.gpg key2.gpg key3.gpg \
  && cd /tmp \
  && git clone -b tor-${TOR_VERSION} https://git.torproject.org/tor.git \
  && cd tor \
  && git verify-tag tor-${TOR_VERSION} \
  && ./autogen.sh \
  && ./configure \
    --disable-asciidoc \
    --sysconfdir=/etc \
    --disable-unittests \
    --enable-static-tor \
    --with-libevent-dir=$(dirname $(dpkg -L libevent-dev | grep libevent.a)) \
    --with-openssl-dir=$(dirname $(dpkg -L libssl-dev | grep libssl.a)) \
    --with-zlib-dir=$(dirname $(dpkg -L zlib1g-dev | grep libz.a)) \
    LIBS="-lzstd -lz" \
  && make -j$(nproc) \
  && gzexe src/app/tor


FROM debian:stable-slim
ARG TOR_USER_ID
ARG GROUP_ID

COPY --from=build /tmp/tor/src/app/tor /usr/local/bin/tor

RUN apt-get update \
  && apt-get install -y --no-install-recommends adduser \
  && rm -rf /var/lib/apt/lists/* \
  && addgroup --gid ${GROUP_ID} tor \
  && adduser --disabled-password --gecos "" --uid ${TOR_USER_ID} --ingroup tor tor \
  && apt-get remove -y adduser

USER tor

CMD tor -f ~/torrc.default
