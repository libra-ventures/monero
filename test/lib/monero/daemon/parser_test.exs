defmodule Monero.Daemon.ParserTest do
  use ExUnit.Case, async: true
  alias Monero.Daemon.Parser

  test "error parsing" do
    assert Parser.parse({:error, "error"}, "action", %{}) == {:error, "error"}
  end

  test "json rpc calls parsing" do
    body = ~s<{"id": "0", "jsonrpc": "2.0", "result" :{"fee": 382440000, "status": "OK"}}>
    expected = {:ok, %{"fee" => 382_440_000, "status" => "OK"}}

    assert Parser.parse({:ok, %{body: body}}, "json_rpc", [json_codec: Test.JSONCodec]) == expected
  end

  test "rest calls parsing" do
    body = ~s<{"height": 993488,"status": "OK"}>
    expected = {:ok, %{"height" => 993_488, "status" => "OK"}}

    assert Parser.parse({:ok, %{body: body}}, "getheight", [json_codec: Test.JSONCodec]) == expected
  end
end
