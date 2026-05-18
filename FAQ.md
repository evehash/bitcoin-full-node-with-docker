# Frequently Asked Questions

## Do you plan to add support for Lightning Network (LND)?

The short answer is no.

Adding LND considerably increases the complexity of the project and its maintenance. It requires channel backups, liquidity management, watchtowers or other monitoring strategies, and extra operational care if the node goes down or loses connectivity.

For the time being, it is not on the roadmap. This project focuses on a Bitcoin full node, Electrs, BTC RPC Explorer and privacy networks.

## Why build locally instead of publishing Docker images?

The goal of this repository is to make the node stack auditable from source. Pulling prebuilt images would be more convenient, but it would also move trust to a registry and to whoever built those images.

The intended workflow is to build locally from upstream source code. Where upstream projects provide signed tags or source signatures, the Dockerfiles verify them during the build.

## Why Alpine for most images?

The current Dockerfiles build static or mostly self-contained binaries on Alpine where practical. This keeps runtime images small while still allowing source verification during the build stage.

Some services may use a different base image when their runtime requirements make it more appropriate. For example, BTC RPC Explorer runs on Node.js and uses the official slim Node image at runtime.
