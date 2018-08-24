use Mix.Config

config :logger, :console,
  level: :debug,
  format: "$date $time [$level] $metadata$message\n"

import_config "#{Mix.env()}.exs"
