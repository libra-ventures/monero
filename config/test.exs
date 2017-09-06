use Mix.Config

config :logger, level: :warn

config :ex_monero,
  json_codec: Test.JSONCodec

config :ex_monero, :wallet,
  url: "http://127.0.0.1:18081"

