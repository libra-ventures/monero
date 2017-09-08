defmodule ExMonero.AuthTest do
  use ExUnit.Case, async: true
  alias ExMonero.Auth
  import Support.WalletHelpers

  setup do
    {:ok, method: :post, url: "http://127.0.0.1:18081/json_rpc"}
  end

  describe "headers/2" do
    test "adds digest auth header to the list of the headers", %{method: method, url: url} do
      type_header = List.first(request_headers())
      {:ok, headers} = Auth.headers(method, url, service_config(), response_headers(), [type_header])

      assert [{"Authorization", "Digest" <> _rest}, ^type_header] = headers
    end

    test "replaces digest auth header in the list of the headers", %{method: method, url: url} do
      diges_header  = {"Authorization", "XDigest cnonce=\"d5c3d965\",nc=00000001"}
      {:ok, headers} = Auth.headers(method, url, service_config(), response_headers(), [diges_header])

      assert [{"Authorization", "Digest" <> _rest}] = headers
    end

    test "returns error if user and/or password wasn't set", %{method: method, url: url} do
      config = service_config(%{user: nil})
      {:error, "Authorization required" <> _rest} = Auth.headers(method, url, config, response_headers(), [])

      config = service_config(%{password: nil})
      {:error, "Authorization required" <> _rest} = Auth.headers(method, url, config, response_headers(), [])

      config = service_config(%{user: nil, password: nil})
      {:error, "Authorization required" <> _rest} = Auth.headers(method, url, config, response_headers(), [])
    end
  end
end
