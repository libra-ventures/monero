defmodule Monero.Wallet do
  @moduledoc """
  Operations on Monero wallet RPC. See https://getmonero.org/resources/developer-guides/wallet-rpc.html or
  https://lessless.github.io/#wallet-json-rpc-calls temporarly.
  """

  @doc """
  Return the wallet's balance.

  Args:
  * account_index - Return balance for this account.
  """
  @spec getbalance(non_neg_integer()) :: Monero.Operation.Query.t()
  def getbalance(account_index \\ 0) do
    request("getbalance", %{account_index: account_index})
  end

  @doc """
  Return the wallet's address.

  Args:

  * `account_index` - Return subaddresses for this account.
  * `address_index` - (optional) List of subaddresses to return from an account.

  """
  @spec getaddress(non_neg_integer(), list(non_neg_integer())) :: Monero.Operation.Query.t()
  def getaddress(account_index \\ 0, address_index \\ []) do
    request("getaddress", %{account_index: account_index, address_index: address_index})
  end

  @doc "Returns the wallet's current block height."
  @spec getheight() :: Monero.Operation.Query.t()
  def getheight() do
    request("getheight")
  end

  @doc """
  Get a list of incoming payments using a given payment id.

  Args:
  * `payment_id` - Payment id of incoming payments.
  """
  @spec get_payments(String.t()) :: Monero.Operation.Query.t()
  def get_payments(payment_id) do
    request("get_payments", %{payment_id: payment_id})
  end

  @doc """
  Return a list of incoming transfers to the wallet.

  Args:
  * `transfer_type` - may be one of the:
    * `"all"` - for all the transfers.
    * `"available"` - for only transfers which are not yet spent.
    * `"unavailable"` - for only transfers which are already spent.
  """
  @spec incoming_transfers(Strint.t()) :: Monero.Operation.Query.t()
  def incoming_transfers(transfer_type) do
    request("incoming_transfers", %{transfer_type: transfer_type})
  end

  @doc """
  Create a new wallet. You need to have set the argument `--wallet-dir` when
  launching monero-wallet-rpc to make this work.

  Args:
  * `filename` - Filename for your wallet.
  * `password` - Password for your wallet.
  * `language` - Language for your wallets' seed.
  """
  @spec create_wallet(Strint.t(), Strint.t(), Strint.t()) :: Monero.Operation.Query.t()
  def create_wallet(filename, password, language) do
    request("create_wallet", %{filename: filename, password: password, language: language})
  end

  @doc """
  Open a wallet. You need to have set the argument `--wallet-dir` when
  launching monero-wallet-rpc to make this work.

  Args:
  * `filename` - Filename for your wallet.
  * `password` - Password for your wallet.
  """
  @spec open_wallet(Strint.t(), Strint.t()) :: Monero.Operation.Query.t()
  def open_wallet(filename, password) do
    request("open_wallet", %{filename: filename, password: password})
  end

  @type transfer_destination :: %{amount: non_neg_integer(), address: String.t()}

  @type transfer_opts ::
          {:payment_id, String.t()}
          | {:get_tx_key, boolean}
          | {:priority, non_neg_integer}
          | {:do_not_relay, boolean}
          | {:get_tx_hex, boolean}

  @doc """
  Send monero to a number of recipients.

  Args:
  * `destinations` - List of destinations to receive XMR.
  * `account_index` - Transfer from this account index.
  * `subaddr_indices` - Transfer from this set of subaddresses.
  * `mixin` - Number of outputs from the blockchain to mix with.
  * `unlock_time` - Number of blocks before the monero can be spent (0 to not add a lock)
  * optional arguments in a form of keyword list as described in the documentation

  **NOTE:** destination amount is in atomic units, means 1e12 = 1 XMR
  """
  @spec transfer(
          [transfer_destination()],
          non_neg_integer(),
          [non_neg_integer()],
          non_neg_integer(),
          non_neg_integer(),
          transfer_opts()
        ) :: Monero.Operation.Query.t()
  def transfer(destinations, account_index, subaddr_indices, mixin, unlock_time, opts \\ []) do
    params =
      opts
      |> build_opts([:payment_id, :get_tx_key, :priority, :do_not_relay, :get_tx_hex, :get_tx_metadata])
      |> Map.merge(%{
        destinations: destinations,
        account_index: account_index,
        subaddr_indices: subaddr_indices,
        mixin: mixin,
        unlock_time: unlock_time
      })

    request("transfer", params)
  end

  @doc """
  Create a new account with an optional label.

  Args:
  * `label` - Label for the account.
  """
  @spec create_account(String.t()) :: Monero.Operation.Query.t()
  def create_account(label \\ "") do
    request("create_account", %{label: label})
  end

  @doc """
  Label an account.

  Args:
  * `account_index` - Apply label to account at this index.
  * `label` - Label for the account.
  """
  @spec label_account(non_neg_integer(), String.t()) :: Monero.Operation.Query.t()
  def label_account(account_index \\ 0, label \\ "") do
    request("label_account", %{account_index: account_index, label: label})
  end

  @doc """
  Get all accounts for a wallet. Optionally filter accounts by tag.

  Args:
    * `tag` - Tag for filtering accounts (optional).
  """
  @spec get_accounts(String.t()) :: Monero.Operation.Query.t()
  def get_accounts(tag \\ "") do
    request("get_accounts", %{tag: tag})
  end

  ## Request
  ######################

  defp request(method, params \\ nil) do
    %Monero.Operation.Query{
      path: "/json_rpc",
      data: %{jsonrpc: "2.0", method: method, params: params},
      service: :wallet,
      parser: &Monero.Wallet.Parser.parse/2
    }
  end

  ## Utils
  ######################

  defp build_opts(opts, permitted), do: opts |> Map.new() |> Map.take(permitted)
end
