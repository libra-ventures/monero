defmodule Monero.JSON.Codec do
  @moduledoc """
  Defines the specification for a JSON codec.

  Monero supports the use of your favorite JSON codec provided it fulfills this specification.
  Poison fulfills this spec without modification, and is the default.

  See the contents of `Monero.JSON.JSX` for an example of an alternative implementation.
  ## Example
  Here for example is the code required to make jsx comply with this spec.

  In your config you would do:

  ```elixir
  config :monero,
    json_codec: Monero.JSON.JSX
  ```

  ```elixir
  defmodule Monero.JSON.JSX do
    @behaviour Monero.JSON.Codec

    @moduledoc false

    def encode!(%{} = map) do
      map |> :jsx.encode
    end

    def encode(map) do
      try do
        {:ok, encode!(map)}
      rescue
        ArgumentError -> {:error, :badarg}
      end
    end

    def decode!(string) do
      :jsx.decode(string, [:return_maps])
    end

    def decode(string) do
      try do
        {:ok, decode!(string)}
      rescue
        ArgumentError -> {:error, :badarg}
      end
    end
  end
  ```
  """

  @callback encode!(%{}) :: String.t
  @callback encode(%{}) :: {:ok, String.t} | {:error, String.t}

  @callback decode!(String.t) :: %{}
  @callback decode(String.t) :: {:ok, %{}} | {:error, %{}}
end
