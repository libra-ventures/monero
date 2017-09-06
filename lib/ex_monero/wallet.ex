defmodule ExMonero.Wallet do
  # import ExAws.Utils, only: [camelize_key: 1, camelize_keys: 1]

  @moduledoc """
  Operations on AWS SES

  http://docs.aws.amazon.com/ses/latest/APIReference/Welcome.html
  """

  @notification_types [:bounce, :complaint, :delivery]

  @doc "Return the wallet's balance."
  @spec getbalance() :: ExMonero.Operation.Query.t
  def getbalance() do
    request(:getbalance)
  end


  ## Request
  ######################

  defp request(method, params \\ nil) do


    %ExMonero.Operation.Query{
      path: "/json_rpc",
      params: json_rpc_params(method, params),
      service: :wallet,
      parser: &ExMonero.Wallet.Parser.parse/2
    }
  end

  def json_rpc_params(method, params) do
    # method_string = method |> Atom.to_string()
    %{jsonrpc: "2.0", method: method, params: params}
  end
end
