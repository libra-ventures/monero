use Mix.Config

config :monero,
  debug_requests: true

config :monero, :wallet,
  url: "http://127.0.0.1:18081"

config :monero, :daemon,
  url: "http://127.0.0.1:28081"

