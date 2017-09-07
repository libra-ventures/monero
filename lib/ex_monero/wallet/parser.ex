  defmodule ExMonero.Wallet.Parser do
    @moduledoc "Wallet daemon response parser"

    def parse({:error, result}, _), do: {:error, result}
    def parse({:ok, %{body: ""}}, _), do: {:ok, %{}}
    def parse({:ok, %{body: body}}, config) do
      {:ok, config[:json_codec].decode!(body)["result"]}
    end
  end
