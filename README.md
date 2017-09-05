# Exmr

[Monero](https://getmonero.org) API client. Based on the fantastics ExAws project, including copying over network and authentication layers.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exmr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exmr, "~> 0.1.0"}
  ]
end
```



## Development

### Setting up development environment:
- Generate a testnet wallet
- Start a `monero-wallet-rpc` instance

```
monero-wallet-cli --testnet --daemon-host node.xmrbackb.one --generate-new-wallet ~/wallets/xb-testnet
monero-wallet-rpc  --daemon-host node.xmrbackb.one  --testnet --wallet-file wallets/xb-testnet --rpc-bind-port 18081 --rpc-bind-ip 127.0.0.1 --rpc-login user:password
```

Have fun!
