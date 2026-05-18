#!/bin/sh
set -eu

bitcoin-cli \
  -datadir=/home/bitcoin/.bitcoin \
  -rpcwait \
  -rpcwaittimeout=5 \
  getblockchaininfo >/dev/null
