defmodule Test.JSONCodec do
  @behaviour ExMonero.JSON.Codec

  defdelegate encode!(data), to: Poison
  defdelegate encode(data), to: Poison
  defdelegate decode!(data), to: Poison
  defdelegate decode(data), to: Poison
end
