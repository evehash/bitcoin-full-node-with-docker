<div align="center">
  <h1>Bitcoin full node with docker</h1>

  <img alt="Logo" src="./.doc/readme/logo.png" width="480"/>

  <p>
    <strong>A simple way to deploy your own node with Docker!</strong>
  </p>

  <p>
  <a href="https://github.com/reverse-hash/bitcoin-full-node-with-docker/actions/workflows/build.yml">
<img alt="" src="https://github.com/reverse-hash/bitcoin-full-node-with-docker/actions/workflows/build.yml/badge.svg"></a>
  
  </p>

<strong><a href="#documentation">Documentation</a> </strong>
| <strong><a href="https://github.com/reverse-hash/bitcoin-full-node-with-docker/discussions">Support</a></strong>
| <strong><a href="./FAQ.md">FAQ</a></strong>

</div>

## About the project

Deploy a dockerized node accessible from your local network (LAN). Electrs will be available for connecting any Electrum-compatible wallet and BTC Explorer will allow blockchain exploration.

The node will participate in the Bitcoin network by exchanging blocks with other nodes via Tor. Optionally, it can also be made accessible from anywhere through Tor.

The following services are deployed:

| Service                                                                         | Version      | Base image         | Size    |
| ------------------------------------------------------------------------------- | ------------ | ------------------ | --------|
| <a href="https://gitlab.torproject.org/tpo/core/tor/">Tor</a>                   | 0.4.9.6      | alpine:3.23        | 18.2 MB |
| <a href="https://github.com/bitcoin/bitcoin">Bitcoin core</a>                   | 30.2         | alpine:3.23        | 19.9 MB |
| <a href="https://github.com/romanz/electrs">Electrs</a>                         | 0.11.1       | alpine:3.23        | 21.2 MB |
| <a href="https://github.com/janoside/btc-rpc-explorer">Bitcoin RPC Explorer</a> | 3.5.1        | node:22-slim       | 377 MB  |
| <a href="https://github.com/nginxinc/docker-nginx">NGINX</a>                    | stable-slim  | nginx:alpine-slim  | 11.5 MB |
| <a href="https://github.com/i2p/i2p.i2p">i2p</a> (optional)                     | 2.11.0       | alpine:3.23        | 232 MB  |

## Documentation

<a href="#documentation"></a>

- <a href="./GETTING_STARTED.md">Getting started</a>
- <a href="./UPDATING_SERVICES.md">Updating services</a>

## Special thanks and attributions

- Kudos to Emmanuel Rosa for a an initial <a href="https://github.com/emmanuelrosa/bitcoin-onion-nodes">list of nodes for Tor</a>.
- Kudos to <a href="https://github.com/cozybear-dev">cozybear-dev</a> for a true multiarch Tor proxy and multiple improvements in documentation/security.
