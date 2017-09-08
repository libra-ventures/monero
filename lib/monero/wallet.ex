defmodule Monero.Wallet do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/wallet-rpc.html or
  https://lessless.github.io/#wallet-json-rpc-calls temporarly.
  """

  @doc "Return the wallet's balance."
  @spec getbalance() :: Monero.Operation.Query.t
  def getbalance() do
    request("getbalance")
  end

  ## Request
  ######################

  defp request(method, params \\ nil) do
    %Monero.Operation.Query {
      path: "/json_rpc",
      data: %{jsonrpc: "2.0", method: method, params: params},
      service: :wallet,
      parser: &Monero.Wallet.Parser.parse/2
    }
  end
end
