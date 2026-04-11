FROM debian:stable-slim AS build
ARG BITCOIN_VERSION

RUN apt-get update \
  && apt-get install --no-install-recommends -y build-essential ca-certificates cmake curl git gpg gpg-agent patch pkg-config python3 \
  && cd /tmp \
  && curl \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/achow101.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/fanquake.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/glozow.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/guggero.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/hebasto.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/theStack.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/vertiond.gpg \
    -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/willyko.gpg \
  && gpg --import *.gpg \
  && git clone -b v${BITCOIN_VERSION} https://github.com/bitcoin/bitcoin.git \
  && cd bitcoin \
  && git verify-tag v${BITCOIN_VERSION} \
  && cd depends \
  && make -j$(nproc) HOST=$(gcc -dumpmachine) NO_QT=1 NO_QR=1 NO_ZMQ=1 NO_USDT=1 NO_WALLET=1 \
  && cd .. \
  && cmake -B build \
    --toolchain depends/$(gcc -dumpmachine)/toolchain.cmake \
    -DBUILD_BENCH=OFF \
    -DBUILD_CLI=OFF \
    -DENABLE_EXTERNAL_SIGNER=OFF \
    -DBUILD_FUZZ_BINARY=OFF \
    -DBUILD_TESTS=OFF \
    -DINSTALL_MAN=OFF \
    -DREDUCE_EXPORTS=ON \
    -DAPPEND_LDFLAGS="-static-libstdc++ -s" \
  && cmake --build build -j$(nproc) \
  && gzexe build/bin/bitcoind


FROM debian:stable-slim
ARG BITCOIN_USER_ID
ARG GROUP_ID

COPY --from=build /tmp/bitcoin/build/bin/bitcoind /usr/local/bin/bitcoind

RUN apt-get update \
  && apt-get install -y --no-install-recommends adduser \
  && rm -rf /var/lib/apt/lists/* \
  && addgroup --gid ${GROUP_ID} bitcoin \
  && adduser -u ${BITCOIN_USER_ID} --disabled-password --gecos "" --ingroup bitcoin bitcoin \
  && apt-get remove -y adduser \
  && mkdir /home/bitcoin/.bitcoin \
  && chown bitcoin:bitcoin /home/bitcoin/.bitcoin

USER bitcoin

CMD bitcoind
