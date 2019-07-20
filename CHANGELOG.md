### Monero 0.11.0

Added:
  - `Wallet` service calls:
    - `get_transfer_by_txid`
    - `sign`
    - `verify`

Changed:
  - `Wallet` service calls:
    - `transfer` - `mixin` and `unlock_time` became optional params
### Monero 0.10.0

Added:

  - `Daemon` service with following calls
    - `sendrawtransaction`
    - `get_fee_estimate`
    - `getheight`
  - `Wallet` service calls:
    - `getaddress`
    - `get_payments`
    - `incoming_transfers`
    - `create_wallet`
    - `transfer`

Updates:

  - `Request.request` method cleanup
  - Fix double-nested `Wallet` configuration structure in the `README`
  - Properly handle misconfigured service errors, like wrong `--wallet-file` argument

### Monero 0.9.0

Using ExAws as a foundation allowed us to inherit following features for free:

  - Retry with exponential backoff
  - Bring your own http/json backend
  - Runtime configuration using environment variables
  - Per request configuration override

Added:

  - HTTP digest authentication(because we want security, yay!)
  - `Wallet` service and `getbalance` call
