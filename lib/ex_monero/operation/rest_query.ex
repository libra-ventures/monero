defmodule ExMonero.Operation.RestQuery do
  defstruct [
    http_method: nil,
    path: "/",
    params: %{},
    body: "",
    service: nil,
    action: nil,
    parser: &ExMonero.Utils.identity/2,
  ]

  @type t :: %__MODULE__{}
end

defimpl ExMonero.Operation, for: ExMonero.Operation.RestQuery do
  def perform(operation, config) do
    headers = []
    url = ExMonero.Request.Url.build(operation, config)
    ExMonero.Request.request(operation.http_method, url, operation.body, headers, config, operation.service)
    |> operation.parser.(operation.action)
  end

  def stream!(%{stream_builder: fun}, config) do
    fun.(config)
  end
end
