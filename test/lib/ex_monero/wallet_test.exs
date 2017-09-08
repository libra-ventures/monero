defmodule ExMonero.WalletTest do
  use ExUnit.Case, async: true
  alias ExMonero.Wallet

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :wallet} = Wallet.getbalance()
  end

  test "#getbalance" do
    expected = %{jsonrpc: "2.0", method: "getbalance", params: nil}
    assert expected == Wallet.getbalance().data
  end
end
