defmodule Monero.WalletTest do
  use ExUnit.Case, async: true
  alias Monero.Wallet

  test "common settings endpoint" do
    assert %{path: "/json_rpc", service: :wallet} = Wallet.getbalance()
  end

  test "getbalance/1" do
    expected = %{jsonrpc: "2.0", method: "getbalance", params: %{account_index: 0}}
    assert expected == Wallet.getbalance().data
  end

  test "getheight/0" do
    expected = %{jsonrpc: "2.0", method: "getheight", params: nil}
    assert expected == Wallet.getheight().data
  end

  test "getaddress/2" do
    expected = %{jsonrpc: "2.0", method: "getaddress", params: %{account_index: 0, address_index: []}}
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

  test "transfer/3" do
    dst = %{
      address: "9wq792k9sxVZiLn66S3Qzv8QfmtcwkdXgM5cWGsXAPxoQeMQ79md51PLPCijvzk1iHbuHi91pws5B7iajTX9KTtJ4bh2tCh",
      amount: 3_000_000_000_000
    }

    params = [
      payment_id: "test-payment",
      account_index: 0,
      subaddr_indices: [],
      get_tx_key: true,
      priority: 1,
      do_not_relay: true,
      get_tx_hex: true
    ]

    expected_params =
      params
      |> Map.new()
      |> Map.merge(%{destinations: [dst], mixin: 6, unlock_time: 60})

    expected = %{jsonrpc: "2.0", method: "transfer", params: expected_params}
    assert expected == Wallet.transfer([dst], 0, [], 6, 60, params ++ [fake: "not-permitted"]).data
  end

  test "create_account/1" do
    expected = %{jsonrpc: "2.0", method: "create_account", params: %{label: "Secondary account"}}
    assert expected == Wallet.create_account("Secondary account").data
  end

  test "label_account/2" do
    expected = %{jsonrpc: "2.0", method: "label_account", params: %{account_index: 2, label: "Secondary account"}}
    assert expected == Wallet.label_account(2, "Secondary account").data
  end

  test "get_accounts/1" do
    expected = %{jsonrpc: "2.0", method: "get_accounts", params: %{tag: "Bob Account"}}
    assert expected == Wallet.get_accounts("Bob Account").data
  end
end
