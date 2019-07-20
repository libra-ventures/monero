defmodule Monero.Config do
  @moduledoc """
  Generates the configuration for a service. It starts with the defaults for a
  given environment and then merges in the common config from the monero
  config root, and then finally any config specified for the particular service
  """

  @common_config [
    :http_client,
    :json_codec,
    :debug_requests,
    :retries
  ]

  @type t :: %{} | Keyword.t()

  @doc """
  Builds a complete set of config for an operation.

  1) Defaults are pulled from `Monero.Config.Defaults`
  2) Common values set via e.g `config :monero` are merged in.
  3) Keys set on the individual service e.g `config :monero, :wallet` are merged in
  4) Finally, any configuration overrides are merged in
  """
  def new(service, opts \\ []) do
    overrides = Map.new(opts)

    service
    |> build_base(overrides)
    |> retrieve_runtime_config()
  end

  def build_base(service, overrides \\ %{}) do
    configuration_root = :monero
    defaults = Monero.Config.Defaults.get(service)
    common_config = configuration_root |> Application.get_all_env() |> Map.new() |> Map.take(@common_config)
    service_config = configuration_root |> Application.get_env(service, []) |> Map.new()

    defaults
    |> Map.merge(common_config)
    |> Map.merge(service_config)
    |> Map.merge(overrides)
  end

  def retrieve_runtime_config(config) do
    Enum.reduce(config, config, fn
      {:url, url}, config ->
        Map.put(config, :url, retrieve_runtime_value(url, config))

      {:retries, retries}, config ->
        Map.put(config, :retries, retries)

      {:http_opts, http_opts}, config ->
        Map.put(config, :http_opts, http_opts)

      {k, v}, config ->
        case retrieve_runtime_value(v, config) do
          %{} = result -> Map.merge(config, result)
          value -> Map.put(config, k, value)
        end
    end)
  end

  def retrieve_runtime_value({:system, env_key}, _) do
    System.get_env(env_key)
  end

  def retrieve_runtime_value(values, config) when is_list(values) do
    values
    |> Stream.map(&retrieve_runtime_value(&1, config))
    |> Enum.find(& &1)
  end

  def retrieve_runtime_value(value, _), do: value
end
