FROM alpine:3.23 AS build

ARG BTC_RPC_EXPLORER_VERSION
ARG BTC_RPC_EXPLORER_COMMIT=8ed77ab225f5507c521b570d5240624de597ad44

# Install build dependencies only in the builder stage.
RUN apk add --no-cache \
      git \
      nodejs \
      npm \
      python3

WORKDIR /opt

# Pin the release tag to the expected commit because upstream tag verification is not available here.
RUN git clone --depth 1 --branch v${BTC_RPC_EXPLORER_VERSION} https://github.com/janoside/btc-rpc-explorer.git \
  && cd btc-rpc-explorer \
  && test "$(git rev-parse HEAD)" = "${BTC_RPC_EXPLORER_COMMIT}"

WORKDIR /opt/btc-rpc-explorer

# Install application dependencies after the source reference has been pinned.
RUN npm install


FROM node:22-slim

ARG BTC_RPC_EXPLORER_USER_ID
ARG GROUP_ID

COPY --from=build /opt/btc-rpc-explorer /opt/btcrpcexplorer

# Run BTC RPC Explorer as an unprivileged user while preserving host volume group access.
RUN addgroup --gid $GROUP_ID btcrpcexplorer \
  && adduser -u ${BTC_RPC_EXPLORER_USER_ID} --disabled-password --gecos "" --ingroup btcrpcexplorer btcrpcexplorer \
  && mkdir /home/btcrpcexplorer/.config \
  && chown btcrpcexplorer:btcrpcexplorer /home/btcrpcexplorer/.config

WORKDIR /opt/btcrpcexplorer
USER btcrpcexplorer

CMD ["npm", "start"]
