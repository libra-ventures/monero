### Monero v0.9.0

Using ExAws as a foundation allowed us to inherit following features for free:

  - Retry with exponential backoff
  - Bring your own http/json backend
  - Runtime configuration using environment variables
  - Per request configuration override

Added:

  - HTTP digest authentication(because we want security, yay!)
  - `Wallet` service and `getbalance` call
