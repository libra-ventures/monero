defmodule Monero.WalletTest do
  use ExUnit.Case, async: true
  alias Monero.Wallet

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :wallet} = Wallet.getbalance()
  end

  test "getbalance/0" do
    expected = %{jsonrpc: "2.0", method: "getbalance", params: nil}
    assert expected == Wallet.getbalance().data
  end

  test "getaddress/0" do
    expected = %{jsonrpc: "2.0", method: "getaddress", params: nil}
    assert expected == Wallet.getaddress().data
  end

  test "get_payments/1" do
    params = %{payment_id: "0000000000000000"}
    expected = %{jsonrpc: "2.0", method: "get_payments", params: params}
    assert expected == Wallet.get_payments("0000000000000000").data
  end

  test "incoming_transfers/1" do
    expected = %{jsonrpc: "2.0", method: "incoming_transfers", params: %{transfer_type: "all"}}
    assert expected == Wallet.incoming_transfers("all").data
  end

  test "create_wallet/3" do
    params = %{filename: "test-wallet", password: "password", language: "English"}
    expected = %{jsonrpc: "2.0", method: "create_wallet", params: params}
    assert expected == Wallet.create_wallet("test-wallet", "password", "English").data
  end

  test "open_wallet/3" do
    params = %{filename: "test-wallet", password: "password"}
    expected = %{jsonrpc: "2.0", method: "open_wallet", params: params}
    assert expected == Wallet.open_wallet("test-wallet", "password").data
  end
end
