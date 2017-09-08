defmodule Monero do
  @doc """
  Perform an AWS request

  First build an operation from one of the services, and then pass it to this
  function to perform it.

  This function takes an optional second parameter of configuration overrides.
  This is useful if you want to have certain configuration changed on a per
  request basis.

  ## Examples

  ```
  Monero.S3.list_buckets |> Monero.request

  Monero.S3.list_buckets |> Monero.request(region: "eu-west-1")

  Monero.Dynamo.get_object("users", "foo@bar.com") |> Monero.request
  ```

  """
  @spec request(Monero.Operation.t) :: term
  @spec request(Monero.Operation.t, Keyword.t) :: {:ok, term} | {:error, term}
  def request(op, config_overrides \\ []) do
    Monero.Operation.perform(op, Monero.Config.new(op.service, config_overrides))
  end

  @doc """
  Perform an AWS request, raise if it fails.

  Same as `request/1,2` except it will either return the successful response from
  AWS or raise an exception.
  """
  @spec request!(Monero.Operation.t) :: term | no_return
  @spec request!(Monero.Operation.t, Keyword.t) :: term | no_return
  def request!(op, config_overrides \\ []) do
    case request(op, config_overrides) do
      {:ok, result} ->
        result

      error ->
        raise Monero.Error, """
          Monero Request Error!

          #{inspect error}
          """
    end
  end
end
