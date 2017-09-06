defmodule ExMonero.Operation.Query do
  @moduledoc """
  Datastructure representing an operation on a Query based AWS service

  These include:
  - SQS
  - SNS
  - SES
  """

  defstruct [
    path: "/",
    params: %{},
    service: nil,
    action: nil,
    parser: &ExMonero.Utils.identity/2
  ]

  @type t :: %__MODULE__{}
end

defimpl ExMonero.Operation, for: ExMonero.Operation.Query do
  def perform(operation, config) do
    data = operation.params |> URI.encode_query
    url = operation
    |> Map.delete(:params)
    |> ExMonero.Request.Url.build(config)
    |> IO.inspect(label: "url")
    headers = [
      {"content-type", "application/x-www-form-urlencoded"},
    ]

    result = ExMonero.Request.request(:post, url, data, headers, config, operation.service)
    parser = operation.parser
    cond do
      is_function(parser, 2) ->
        parser.(result, operation.action)
      is_function(parser, 3) ->
        parser.(result, operation.action, config)
      true ->
        result
    end
  end

  def stream!(_, _), do: nil
end
