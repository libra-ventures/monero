defmodule Support.BypassHelpers do
  def start_bypass(_) do
    bypass = Bypass.open
    [bypass: bypass]
  end


  def service_config_for_bypass(bypass, service \\ :wallet) do
    ExMonero.Config.new(service, [
      user: "user",
      password: "password",
      url: "http://localhost:#{bypass.port}"
    ])
  end

  def bypass_endpoint_url(port), do: "http://localhost:#{port}/json-rpc"
end
