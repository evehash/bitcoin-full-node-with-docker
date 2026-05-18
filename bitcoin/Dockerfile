FROM alpine:3.23 AS build

ARG BITCOIN_VERSION

# Install build dependencies only in the builder stage.
RUN apk add --no-cache \
      autoconf \
      automake \
      build-base \
      ca-certificates \
      cmake \
      curl \
      git \
      gnupg \
      libtool \
      linux-headers \
      patch \
      perl \
      pkgconf \
      python3

WORKDIR /tmp

# Import Bitcoin Core builder keys used to verify release tags.
RUN mkdir -p /root/.gnupg \
  && chmod 700 /root/.gnupg \
  && curl \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/achow101.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/fanquake.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/glozow.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/guggero.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/hebasto.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/theStack.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/vertiond.gpg \
      -O https://raw.githubusercontent.com/bitcoin-core/guix.sigs/main/builder-keys/willyko.gpg \
  && gpg --batch --import *.gpg

RUN git clone \
      --depth 1 \
      --branch "v${BITCOIN_VERSION}" \
      https://github.com/bitcoin/bitcoin.git

WORKDIR /tmp/bitcoin

# Verify the upstream release before compiling.
RUN git verify-tag "v${BITCOIN_VERSION}"

# Build bitcoind and bitcoin-cli for a headless full node; skip wallet, GUI, tests, benchmarks and extra tools.
RUN case "$(apk --print-arch)" in \
       x86_64)  HOST=x86_64-alpine-linux-musl ;; \
       aarch64) HOST=aarch64-alpine-linux-musl ;; \
       armv7)   HOST=armv7-alpine-linux-musleabihf ;; \
       ppc64le) HOST=powerpc64le-alpine-linux-musl ;; \
       s390x)   HOST=s390x-alpine-linux-musl ;; \
       *) echo "Unsupported arch: $(apk --print-arch)" >&2; exit 1 ;; \
     esac \
  && cd depends \
  && make -j"$(nproc)" HOST="$HOST" NO_BDB=1 NO_QT=1 NO_QR=1 NO_SQLITE=1 NO_NATPMP=1 NO_UPNP=1 NO_ZMQ=1 NO_USDT=1 NO_WALLET=1 \
  && cd .. \
  && cmake -B build \
      --toolchain "depends/$HOST/toolchain.cmake" \
      -DAPPEND_LDFLAGS="-static -static-libgcc -static-libstdc++ -s" \
      -DBUILD_BENCH=OFF \
      -DBUILD_BITCOIN_BIN=OFF \
      -DBUILD_CLI=ON \
      -DBUILD_FUZZ_BINARY=OFF \
      -DBUILD_TESTS=OFF \
      -DBUILD_TX=OFF \
      -DBUILD_UTIL=OFF \
      -DENABLE_EXTERNAL_SIGNER=OFF \
      -DENABLE_IPC=OFF \
      -DENABLE_WALLET=OFF \
      -DINSTALL_MAN=OFF \
      -DREDUCE_EXPORTS=ON \
      -DWITH_ZMQ=OFF \
  && cmake --build build -j"$(nproc)" \
  && strip build/bin/bitcoind build/bin/bitcoin-cli \
  && cp build/bin/bitcoind /tmp/bitcoind-bin \
  && cp build/bin/bitcoin-cli /tmp/bitcoin-cli-bin


FROM alpine:3.23

ARG BITCOIN_USER_ID=1000
ARG GROUP_ID=1000

COPY --from=build /tmp/bitcoind-bin /usr/local/bin/bitcoind
COPY --from=build /tmp/bitcoin-cli-bin /usr/local/bin/bitcoin-cli
COPY healthcheck.sh /usr/local/bin/bitcoin-healthcheck

# Run the daemon as an unprivileged user while preserving host volume group access.
RUN addgroup -g "${GROUP_ID}" bitcoin \
  && adduser -u "${BITCOIN_USER_ID}" -D -G bitcoin -h /home/bitcoin bitcoin \
  && mkdir -p /home/bitcoin/.bitcoin \
  && chown -R bitcoin:bitcoin /home/bitcoin \
  && chmod +x /usr/local/bin/bitcoin-healthcheck

USER bitcoin
WORKDIR /home/bitcoin

ENTRYPOINT ["/usr/local/bin/bitcoind"]
CMD ["-datadir=/home/bitcoin/.bitcoin"]
