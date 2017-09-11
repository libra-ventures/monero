  defmodule Monero.Daemon.Parser do
    @moduledoc "Wallet daemon response parser"

    def parse({:error, result}, _, _), do: {:error, result}

    def parse({:ok, %{body: ""}}, _, _), do: {:ok, %{}}

    def parse({:ok, %{body: body}}, action, config) when action == "json_rpc" do
      {:ok, config[:json_codec].decode!(body)["result"]}
    end

    def parse({:ok, %{body: body}}, _, config) do
      {:ok, config[:json_codec].decode!(body)}
    end
  end
