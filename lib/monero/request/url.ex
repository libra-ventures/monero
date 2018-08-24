defmodule Monero.Request.Url do
  @moduledoc false

  @doc """
  Builds URL for an operation and a config"
  """
  def build(operation, config) do
    config.url
    |> URI.parse()
    |> Map.put(:path, operation.path)
    |> normalize_path()
    |> URI.to_string()
    |> String.trim_trailing("?")
  end

  defp normalize_path(url) do
    Map.update(url, :path, "", &String.replace(&1, ~r/\/{2,}/, "/"))
  end
end
