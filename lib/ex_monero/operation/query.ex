defmodule ExMonero.Operation.Query do
  @moduledoc """
  Datastructure representing an operation on a Monero Daemon endpoint
  """

  defstruct [
    path: "/",
    data: %{},
    service: nil,
    action: nil,
    parser: &ExMonero.Utils.identity/2
  ]

  @type t :: %__MODULE__{}
end

defimpl ExMonero.Operation, for: ExMonero.Operation.Query do
  def perform(operation, config) do
    url = ExMonero.Request.Url.build(operation, config)

    headers = [
      {"content-type", "application/json"},
    ]

    result = ExMonero.Request.request(:post, url, operation.data, headers, config, operation.service)
    parser = operation.parser

    cond do
      is_function(parser, 2) ->
        parser.(result, config)
      is_function(parser, 3) ->
        parser.(result, operation.action, config)
      true ->
        result
    end
  end

  def stream!(_, _), do: nil
end
