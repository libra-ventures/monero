defmodule ExMonero.ConfigTest do
  use ExUnit.Case, async: true

  test "{:system} style configs work" do
    value = "foo"
    System.put_env("ExMoneroConfigTest", value)
    assert :wallet
    |> ExMonero.Config.new([url: {:system, "ExMoneroConfigTest"}, user: {:system, "MONERO_WALLET_RPC_USER"}])
    |> Map.get(:url) == value
  end
end
