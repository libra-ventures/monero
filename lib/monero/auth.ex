defmodule Monero.Auth do
  @moduledoc "Authorization related functions"

  @doc "Add or replace HTTP Digest auth header in the list of supplied headers"
  def headers(http_method, url, config, challenge_headers, headers) do
    if has_auth_credentials?(config) do
      headers = Enum.reject(headers, fn {name, _} -> String.downcase(name) == "authorization" end)
      auth_header = digest_auth_header(http_method, url, config, challenge_headers)
      {:ok, [auth_header | headers]}
    else
      {:error, "Authorization required, but credentials are not provided or incomplete"}
    end
  end

  defp has_auth_credentials?(config) do
    Map.get(config, :user) && Map.get(config, :password)
  end

  defp digest_auth_header(http_method, url, config, challenge_headers) do
    uri = URI.parse(url)
    method_string = http_method |> Atom.to_string() |> String.upcase()
    %{"Authorization" => auth_response} = Httpdigest.create_header(
      challenge_headers, config.user, config.password, method_string, uri.path
    )

    {"Authorization", auth_response}
  end
end
