defmodule ExMonero.Wallet do
  # import ExAws.Utils, only: [camelize_key: 1, camelize_keys: 1]

  @moduledoc """
  Operations on AWS SES

  http://docs.aws.amazon.com/ses/latest/APIReference/Welcome.html
  """

  @doc "Return the wallet's balance."
  @spec getbalance() :: ExMonero.Operation.Query.t
  def getbalance() do
    request("getbalance")
  end

  ## Request
  ######################

  defp request(method, params \\ nil) do
    %ExMonero.Operation.Query {
      path: "/json_rpc",
      data: %{jsonrpc: "2.0", method: method, params: params},
      service: :wallet,
      parser: &ExMonero.Wallet.Parser.parse/2
    }
  end
end
