FROM debian:stable-slim AS build
ARG ELECTRS_VERSION
RUN apt-get update \
  && apt-get install --no-install-recommends -y build-essential ca-certificates cargo cmake libclang-dev curl git openssh-client \
  && cd /tmp \
  && git clone --branch v${ELECTRS_VERSION} https://github.com/romanz/electrs.git \
  && cd electrs \
  && curl -fsSL https://raw.githubusercontent.com/romanz/keys/refs/heads/main/README.md | grep git@romanzey.de > /tmp/allowed_signers \
  && git config gpg.ssh.allowedSignersFile /tmp/allowed_signers \
  && git verify-tag v${ELECTRS_VERSION} \
  && cargo build --no-default-features --locked --release \
  && gzexe target/release/electrs \
  && apt-get remove build-essential cargo cmake clang curl git -y


FROM debian:stable-slim
ARG ELECTRS_USER_ID
ARG GROUP_ID
COPY --from=build /tmp/electrs/target/release/electrs /usr/local/bin/electrs
RUN apt-get update \
  && apt-get install -y --no-install-recommends adduser \
  && addgroup --gid ${GROUP_ID} electrs \
  && adduser -u ${ELECTRS_USER_ID} --disabled-password --gecos "" --ingroup electrs electrs \
  && mkdir /home/electrs/.electrs \
  && chown electrs:electrs /home/electrs/.electrs

USER electrs

CMD electrs --conf ~/.electrs/electrs.conf
