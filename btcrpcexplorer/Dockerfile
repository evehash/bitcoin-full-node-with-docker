FROM alpine:3.23 AS build
ARG BTC_RPC_EXPLORER_VERSION
RUN apk add --update --no-cache curl git gpg gpg-agent nodejs npm python3 \
  && cd /opt \
  && curl -fsSL https://keybase.io/danjanosik/pgp_keys.asc > keys.asc \
  && gpg --import keys.asc \
  && git clone --branch v${BTC_RPC_EXPLORER_VERSION} https://github.com/janoside/btc-rpc-explorer.git \
  && cd btc-rpc-explorer \
#  && git verify-tag v${BTC_RPC_EXPLORER_VERSION} \ FIXME: not working. Requested to btc-rpc-explorer developers
  && npm install \
  && chmod 755 -R .


FROM node:22-slim
ARG BTC_RPC_EXPLORER_USER_ID
ARG GROUP_ID
COPY --from=build /opt/btc-rpc-explorer /opt/btcrpcexplorer
RUN addgroup --gid $GROUP_ID btcrpcexplorer \
  && adduser -u ${BTC_RPC_EXPLORER_USER_ID} --disabled-password --gecos "" --ingroup btcrpcexplorer btcrpcexplorer \
  && mkdir /home/btcrpcexplorer/.config \
  && chown btcrpcexplorer:btcrpcexplorer /home/btcrpcexplorer/.config

USER btcrpcexplorer

WORKDIR /opt/btcrpcexplorer
CMD npm start
