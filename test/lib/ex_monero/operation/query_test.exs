defmodule Monero.Operation.QueryTest do
  use ExUnit.Case, async: true
  import Support.BypassHelpers

  describe "perform/2" do
    setup do
      bypass = Bypass.open()
      config = service_config_for_bypass(bypass)
      operation = %Monero.Operation.Query {
        path: "/json_rpc",
        data: %{jsonrpc: "2.0", method: :getbalance, params: ""},
        service: :wallet,
        parser: fn status, result ->
          send(self(), :parser_called)
          Monero.Wallet.Parser.parse(status, result)
        end
      }

      {:ok, bypass: bypass, config: config, operation: operation}
    end

    test "it sends a request with default header and calls parser", %{bypass: bypass, config: config, operation: op} do

      Bypass.expect bypass, "POST", "/json_rpc", fn conn ->
        assert header_present?(conn.req_headers, {"content-type", "application/json"})
        Plug.Conn.resp(conn, 200, ~s<{"id": "0","jsonrpc": "2.0","result" :{"count": 993163,"status": "OK"}}>)
      end

      assert {:ok, %{"count" => 993_163, "status" => "OK"}} = Monero.Operation.perform(op, config)
      assert_receive :parser_called
    end
  end
end
