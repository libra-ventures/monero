  defmodule Monero.Wallet.Parser do
    @moduledoc "Wallet daemon response parser"

    def parse({:error, result}, _), do: {:error, result}
    def parse({:ok, %{body: ""}}, _), do: {:ok, %{}}
    def parse({:ok, %{body: body}}, config) do
      parsed_body = config[:json_codec].decode!(body)

      case parsed_body["result"] do
        nil -> {:error, parsed_body["error"]}
        result -> {:ok, result}
      end
    end
  end
