defmodule Monero.Wallet.ParserTest do
  use ExUnit.Case, async: true
  alias Monero.Wallet.Parser

  test "error parsing" do
    assert Parser.parse({:error, "error"}, %{}) == {:error, "error"}
  end

  test "valid json rpc calls parsing with result in the body" do
    body = ~s<{"id": "0", "jsonrpc": "2.0", "result" :{"balance": 0, "unlocked_balance": 0}}>
    expected = {:ok, %{"balance" => 0, "unlocked_balance" => 0}}

    assert Parser.parse({:ok, %{body: body}}, json_codec: Test.JSONCodec) == expected
  end

  test "valid json rpc calls parsing without result in the body" do
    body = ~s<{"error": {"code": -1, "message": "Failed to open wallet"}, "id": "0", "jsonrpc": "2.0"}>
    expected = {:error, %{"code" => -1, "message" => "Failed to open wallet"}}

    assert Parser.parse({:ok, %{body: body}}, json_codec: Test.JSONCodec) == expected
  end
end
