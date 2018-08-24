defmodule Monero.Daemon do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/daemon-rpc.html or
  https://lessless.github.io temporarly.
  """

  @doc """
  Lookup transaction fee estimate in atomic units

  Args:
  * `grace_blocks` - number of blocks we want the fee to be valid for (optional).
  """
  @spec get_fee_estimate(non_neg_integer()) :: Monero.Operation.Query.t()
  def get_fee_estimate(grace_blocks \\ 0) do
    rpc_request("get_fee_estimate", %{grace_blocks: grace_blocks})
  end

  @doc "Get the node's current height."
  @spec getheight() :: Monero.Operation.Query.t()
  def getheight() do
    request("getheight")
  end

  @doc """
  Broadcast a raw transaction to the network.

  Args:
  * `tx_hex` - Full transaction information as hexidecimal string.
  * `do_not_relay` - Stop relaying transaction to other nodes (default is false).
  """
  @spec send_raw_transaction(String.t(), boolean) :: Monero.Operation.Query.t()
  def send_raw_transaction(tx_hex, do_not_relay \\ false) do
    request("sendrawtransaction", %{tx_as_hex: tx_hex, do_not_relay: do_not_relay})
  end

  ## Request
  ######################

  defp rpc_request(method, params \\ nil) do
    request("json_rpc", %{jsonrpc: "2.0", method: method, params: params})
  end

  defp request(action, data \\ %{}) do
    path = "/#{action}"

    %Monero.Operation.Query{
      action: action,
      path: path,
      data: data,
      service: :daemon,
      parser: &Monero.Daemon.Parser.parse/3
    }
  end
end
