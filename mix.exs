defmodule ExMonero.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ex_monero,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      elixirc_paths: elixirc_paths(Mix.env),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ExMonero.Application, []}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib",]

  defp deps do
    [
      {:hackney,  "~> 1.9",   optional: true},
      {:jsx,      "~> 2.8",   optional: true},
      {:poison,   ">= 3.0.0", optional: true},
      {:dialyze,  "~> 0.2.0", only: :dev},
      {:bypass,   "~> 0.7",   only: :test}
    ]
  end
end
