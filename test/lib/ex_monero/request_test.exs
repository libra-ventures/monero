defmodule ExMonero.RequestTest do
  use ExUnit.Case, async: true
  alias ExMonero.Request
  import Support.BypassHelpers

  describe "request/2" do
    setup do
      bypass = Bypass.open()
      config = service_config_for_bypass(bypass)
      url = bypass_endpoint_url(bypass.port)
      data = %{jsonrpc: "2.0", id: "0", method: "on_getblockhash", params: [912_345]}

      {:ok, bypass: bypass, config: config, url: url, data: data}
    end

    test "encodes data", %{config: config, url: url, data: data, bypass: bypass} do
      Bypass.expect_once bypass, fn conn ->
        expected = "{\"params\":[912345],\"method\":\"on_getblockhash\",\"jsonrpc\":\"2.0\",\"id\":\"0\"}"

        assert "/json_rpc" == conn.request_path
        assert "POST" == conn.method
        assert {:ok, ^expected, _} = Plug.Conn.read_body(conn)
        Plug.Conn.resp(conn, 200, "")
      end

      assert {:ok, %{body: ""}} = Request.request(:post, url, data, [], config, :wallet)
    end

    test "provides default data", %{config: config, url: url, bypass: bypass} do
      Bypass.expect_once bypass, fn conn ->
        assert "/json_rpc" == conn.request_path
        assert "POST" == conn.method
        assert {:ok, "{}", _} = Plug.Conn.read_body(conn)
        Plug.Conn.resp(conn, 200, "")
      end

      assert {:ok, %{body: ""}} = Request.request(:post, url, [], [], config, :wallet)
    end

    test "replace spaces", %{config: config, bypass: bypass} do
      url = "http://localhost:#{bypass.port}/json rpc"
      Bypass.expect_once bypass, fn conn ->
        assert "/json%20rpc" == conn.request_path
        assert "POST" == conn.method
        assert {:ok, "{}", _} = Plug.Conn.read_body(conn)
        Plug.Conn.resp(conn, 200, "")
      end

      assert {:ok, %{body: ""}} = Request.request(:post, url, [], [], config, :wallet)
    end

    test "attempts to authorize on 401 authorization required", %{config: config, url: url, bypass: bypass} do
      Agent.start_link(fn -> 0 end, [name: :bypass])

      Bypass.expect bypass, "POST", "/json_rpc", fn conn ->
        case Agent.get(:bypass, & &1) do
          0 ->
            refute header_present?(conn.req_headers, "authorization")
            Agent.update(:bypass, & &1 + 1)
            conn
            |> Plug.Conn.put_resp_header(
              "WWW-authenticate",
              "Digest qop=\"auth\",algorithm=MD5,realm=\"monero-rpc\",nonce=\"BLOGB6SRapJm3nlW626TWg==\",stale=false"
            )
            |> Plug.Conn.resp(401, "")
          1 ->
            assert header_present?(conn.req_headers, "authorization")
            Agent.update(:bypass, & &1 + 1)
            Plug.Conn.resp(conn, 200, "")
           _ -> assert false, "Should have finish on the second request!"
        end
      end

      assert {:ok, %{body: ""}} = Request.request(:post, url, [], [], config, :wallet)
    end

    test "retries with backoff for client-side errors", %{config: config, url: url, bypass: bypass} do
      Agent.start_link(fn -> 0 end, [name: :bypass])

      Bypass.expect bypass, "POST", "/json_rpc", fn conn ->
        code = if Agent.get(:bypass, & &1) < 5, do: 422, else: 200
        Agent.update(:bypass, & &1 + 1)
        Plug.Conn.resp(conn, code, "")
      end

      assert {:ok, %{body: ""}} =  Request.request(:post, url, [], [], config, :wallet)
      assert Agent.get(:bypass, & &1) == 6
    end

    test "retries with backoff for server-side errors", %{config: config, url: url, bypass: bypass} do
      Agent.start_link(fn -> 0 end, [name: :bypass])

      Bypass.expect bypass, "POST", "/json_rpc", fn conn ->
        code = if Agent.get(:bypass, & &1) < 5, do: 500, else: 200
        Agent.update(:bypass, & &1 + 1)
        Plug.Conn.resp(conn, code, "")
      end

      assert {:ok, %{body: ""}} =  Request.request(:post, url, [], [], config, :wallet)
      assert Agent.get(:bypass, & &1) == 6
    end

    test "doesn't retry if not asked and returns error", %{config: config, url: url, bypass: bypass} do
      config = put_in(config, [:retries, :max_attempts], 1)

      Bypass.expect_once bypass, fn conn ->
        Plug.Conn.resp(conn, 500, "error")
      end

      assert {:error, {:http_error, 500, "error"}} = Request.request(:post, url, [], [], config, :wallet)
    end
  end
end
