defmodule Monero.DaemonTest do
  use ExUnit.Case, async: true
  alias Monero.Daemon

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :daemon} = Daemon.get_fee_estimate()
  end

  test "get_fee_estimate/0" do
    expected = %{jsonrpc: "2.0", method: "get_fee_estimate", params: %{grace_blocks: 0}}
    assert expected == Daemon.get_fee_estimate().data
  end

  test "getheight/0" do
    assert %{action: "getheight", path: "/getheight", data: %{}} = Daemon.getheight()
  end

  test "send_raw_transaction/1" do
    tx_hex = "010002028090c...81a2e3bc0039cb0a02"

    assert %{
             action: "sendrawtransaction",
             path: "/sendrawtransaction",
             data: %{tx_as_hex: ^tx_hex, do_not_relay: false}
           } = Daemon.send_raw_transaction(tx_hex)
  end
end
