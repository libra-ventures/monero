defmodule Monero.ConfigTest do
  use ExUnit.Case, async: true

  test "{:system} style configs work" do
    value = "foo"
    System.put_env("MoneroConfigTest", value)

    assert :wallet
           |> Monero.Config.new(url: {:system, "MoneroConfigTest"}, user: {:system, "MONERO_WALLET_RPC_USER"})
           |> Map.get(:url) == value
  end
end
