use Mix.Config

config :logger, level: :warn

config :monero,
  json_codec: Test.JSONCodec

config :monero, :wallet,
  url: "http://127.0.0.1:18081"

