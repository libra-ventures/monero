defmodule Monero.DaemonTest do
  use ExUnit.Case, async: true
  alias Monero.Daemon

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :daemon} = Daemon.get_fee_estimate()
  end

  test "#get_fee_estimate" do
    expected = %{jsonrpc: "2.0", method: "get_fee_estimate", params: nil}
    assert expected == Daemon.get_fee_estimate().data
  end

    test "#getheight" do
    assert %{action: "getheight", path: "/getheight", data: %{}} = Daemon.getheight()
  end
end
