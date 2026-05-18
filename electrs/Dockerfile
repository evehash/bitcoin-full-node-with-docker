FROM alpine:3.23 AS build

ARG ELECTRS_VERSION

# Install build dependencies only in the builder stage.
RUN apk add --no-cache \
      build-base \
      ca-certificates \
      cargo \
      clang-dev \
      cmake \
      curl \
      git \
      linux-headers \
      openssh-client

WORKDIR /tmp

RUN git clone \
      --depth 1 \
      --branch "v${ELECTRS_VERSION}" \
      https://github.com/romanz/electrs.git

WORKDIR /tmp/electrs

# Verify the upstream release tag using the maintainer's SSH signing key.
RUN curl -fsSL https://raw.githubusercontent.com/romanz/keys/refs/heads/main/README.md \
      | grep 'git@romanzey.de' > /tmp/allowed_signers \
  && git config gpg.ssh.allowedSignersFile /tmp/allowed_signers \
  && git verify-tag "v${ELECTRS_VERSION}"

# Build a static electrs binary without optional default features.
RUN case "$(apk --print-arch)" in \
       x86_64)  HOST=x86_64-alpine-linux-musl ;; \
       aarch64) HOST=aarch64-alpine-linux-musl ;; \
       armv7)   HOST=armv7-alpine-linux-musleabihf ;; \
       ppc64le) HOST=powerpc64le-alpine-linux-musl ;; \
       s390x)   HOST=s390x-alpine-linux-musl ;; \
       *) echo "Unsupported arch: $(apk --print-arch)" >&2; exit 1 ;; \
     esac \
  && CXXFLAGS="-include cstdint" \
     RUSTFLAGS="-C target-feature=+crt-static -C link-arg=-static-libstdc++ -C link-arg=-static-libgcc" \
     cargo build --target "$HOST" --no-default-features --locked --release \
  && strip "target/$HOST/release/electrs" \
  && cp "target/$HOST/release/electrs" /tmp/electrs-bin


FROM alpine:3.23

ARG ELECTRS_USER_ID=1000
ARG GROUP_ID=1000

COPY --from=build /tmp/electrs-bin /usr/local/bin/electrs

# Run electrs as an unprivileged user while preserving host volume group access.
RUN addgroup -g "${GROUP_ID}" electrs \
  && adduser -u "${ELECTRS_USER_ID}" -D -G electrs -h /home/electrs electrs \
  && mkdir -p /home/electrs/.electrs \
  && chown -R electrs:electrs /home/electrs

USER electrs
WORKDIR /home/electrs

ENTRYPOINT ["/usr/local/bin/electrs"]
CMD ["--conf", "/home/electrs/.electrs/electrs.conf"]
