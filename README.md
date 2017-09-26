# Monero
[![Build Status](https://travis-ci.org/libra-ventures/monero.svg?branch=master)](https://travis-ci.org/libra-ventures/monero)
[![Coverage Status](https://coveralls.io/repos/github/libra-ventures/monero/badge.svg?branch=master)](https://coveralls.io/github/libra-ventures/monero?branch=master)

[Monero](https://getmonero.org) API client. Based on the fantastics [ExAws](https://github.com/CargoSense/ex_aws) project.

## Getting started

### Setup

Add `monero` to your `mix.exs`, along with your json parser and http client of
choice. Monero works out of the box with Poison and :hackney.

```elixir
def deps do
  [
    {:monero, "~> 1.0"},
    {:poison, "~> 2.0"},
    {:hackney, "~> 1.6"}
  ]
end
```
### Usage

Monero inherits data driven approach to querying APIs. The various
functions that exist inside a service like `Wallet.getbalance()` or
`Daemon.getheight()` all return a struct which holds the information necessary
to make that particular operation.

You then have 4 ways you can choose to execute that operation:

```elixir
# Simple
Wallet.getbalance() |> Monero.request() #=> {:ok, response}
# With per request configuration overrides
Wallet.getbalance() |> Monero.request(config) #=> {:ok, response}

# Raise on error, return successful responses directly
Wallet.getbalance() |> Monero.request!() #=> response
Wallet.getbalance() |> Monero.request!(config) #=> response
```

### Authorization

Monero has by default the equivalent including the following in your mix.exs

```elixir
config :monero, wallet:
  url: {:system, "MONERO_WALLET_RPC_URL"},
  user: {:system, "MONERO_WALLET_RPC_USER"},
  password: {:system, "MONERO_WALLET_RPC_PASSWORD"}
```

This means values from  `MONERO_WALLET_RPC_URL`, `MONERO_WALLET_RPC_USER` and `MONERO_WALLET_RPC_PASSWORD` environment
variables have higher precedence over `:monero` configuration settings

### Retries

Monero will retry failed requests using exponential backoff per the "Full
Jitter" formula described in
https://www.awsarchitectureblog.com/2015/03/backoff.html

The algorithm uses three values, which are configurable:

```elixir
# default values shown below

config :monero, :retries,
  max_attempts: 10,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 10_000
```

* `max_attempts` is the maximum number of possible attempts with backoffs in between each one
* `base_backoff_in_ms` corresponds to the `base` value described in the blog post
* `max_backoff_in_ms` corresponds to the `cap` value described in the blog post


## Development

### Setting up development environment:
- Generate a testnet wallet
- Start a `monero-wallet-rpc` instance

```
monero-wallet-cli --testnet --daemon-host node.xmrbackb.one --generate-new-wallet ~/wallets/xb-testnet
monero-wallet-rpc --daemon-host node.xmrbackb.one --testnet --wallet-file wallets/xb-testnet --rpc-bind-port 18082 --rpc-bind-ip 127.0.0.1 --rpc-login user:password
```

Have fun!


## License

The MIT License (MIT)

Copyright (c) 2017 Libra Ventures.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
