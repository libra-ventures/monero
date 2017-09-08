defmodule Support.BypassHelpers do
  @moduledoc false

  def start_bypass(_) do
    bypass = Bypass.open
    [bypass: bypass]
  end

  def service_config_for_bypass(bypass, service \\ :wallet) do
    Monero.Config.new(service, [
      user: "user",
      password: "password",
      url: "http://localhost:#{bypass.port}"
    ])
  end

  def bypass_endpoint_url(port), do: "http://localhost:#{port}/json_rpc"

  def header_present?(headers, {header_name, header_value}) do
    Enum.any?(headers, fn {name, value} ->
      String.downcase(name) == String.downcase(header_name) && String.downcase(value) == String.downcase(header_value)
    end)
  end

  def header_present?(headers, header_name),
    do: Enum.any?(headers, fn {name, _} -> String.downcase(name) == header_name end)
end
