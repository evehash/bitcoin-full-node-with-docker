# Release vYYYY.N

## Summary

- Short description of the release goal.

## Component Versions

| Component | Version |
| --- | --- |
| Tor | |
| Bitcoin Core | |
| Electrs | |
| BTC RPC Explorer | |
| I2P | |

## Build Verification

- `docker compose --env-file .env.example config`
- `docker compose --env-file .env.example --profile disabled config`
- `docker compose --env-file .env.example build`
- `docker compose --env-file .env.example --profile disabled build`

## Upgrade Notes

- Mention required `.env` changes.
- Mention required configuration changes.
- Mention whether a service rebuild, reindex or data migration is expected.

## Breaking Changes

- None, or list the behavior users must handle before upgrading.

## Known Issues

- None, or list current limitations.
