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

  test "transfer/2" do
    dst = %{
      address: "9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh",
      amount: 3_000_000_000_000
    }

    params = [
      payment_id: "test-payment",
      get_tx_key: true,
      priority: 1,
      do_not_relay: true,
      get_tx_hex: true,
      mixin: 4,
      unlock_time: 60
    ]

    expected_params =
      params
      |> Map.new()
      |> Map.merge(%{destinations: [dst]})

    expected = %{jsonrpc: "2.0", method: "transfer", params: expected_params}
    assert expected == Wallet.transfer([dst], params ++ [fake: "not-permitted"]).data
  end

  test "get_transfer_by_txid/2" do
    tx_id = "f5245378d74a050d0842e2900ce273db1567b5c104b16232e6b4032732bc34c9"
    params = [account_index: 1]

    expected = expected_request_data("get_transfer_by_txid", %{txid: tx_id}, params)

    assert expected == Wallet.get_transfer_by_txid(tx_id, params ++ [fake: "not-permitted"]).data
  end

  defp expected_request_data(method, required, optional) do
    params =
      optional
      |> Map.new()
      |> Map.merge(required)

    %{jsonrpc: "2.0", method: method, params: params}
  end
end
