defmodule ExMonero.Config.Defaults do
  @moduledoc """
  Defaults for each service
  """

  @common %{
    http_client: ExMonero.Request.Hackney,
    json_codec: Poison,
    retries: [
      max_attempts: 10,
      base_backoff_in_ms: 10,
      max_backoff_in_ms: 10_000
    ],
  }

  @defaults %{
    wallet: %{
      url: {:system, "MONERO_WALLET_RPC_URL"},
      user: {:system, "MONERO_WALLET_RPC_USER"},
      password: {:system, "MONERO_WALLET_RPC_PASSWORD"}
    }
  }

  @doc """
  Retrieve the default configuration for a service.
  """
  for {service, config} <- @defaults do
    config = Map.merge(config, @common)
    def get(unquote(service)), do: unquote(Macro.escape(config))
  end
  def get(_), do: %{}
end
