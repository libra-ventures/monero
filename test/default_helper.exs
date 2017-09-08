defmodule Test.JSONCodec do
  @behaviour Monero.JSON.Codec

  defdelegate encode!(data), to: Poison
  defdelegate encode(data), to: Poison
  defdelegate decode!(data), to: Poison
  defdelegate decode(data), to: Poison
end
