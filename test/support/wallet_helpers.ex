defmodule Support.WalletHelpers do
  @moduledoc false

  def service_config(overrides \\ %{}) do
    config = %{
      debug_requests: true,
      http_client: Monero.Request.Hackney,
      json_codec: Poison,
      password: "password",
      retries: [max_attempts: 10, base_backoff_in_ms: 10, max_backoff_in_ms: 10_000],
      url: "http://127.0.0.1:18081",
      user: "user"
    }

    Map.merge(config, overrides)
  end

  def response_headers() do
    [
      {"Server", "Epee-based"},
      {"Content-Length", "98"},
      {"Content-Type", "text/html"},
      {"Last-Modified", "Thu, 07 Sep 2017 19:31:53 GMT"},
      {"Accept-Ranges", "bytes"},
      {
        "WWW-authenticate",
        "Digest qop=\"auth\",algorithm=MD5,realm=\"monero-rpc\",nonce=\"gtC0TFr7I9WKFD1aEZZ9Og==\",stale=false"
      },
      {
        "WWW-authenticate",
        "Digest qop=\"auth\",algorithm=MD5-sess,realm=\"monero-rpc\",nonce=\"gtC0TFr7I9WKFD1aEZZ9Og==\",stale=false"
      }
    ]
  end

  def request_headers() do
    [
      {"content-type", "application/json"}
    ]
  end
end
