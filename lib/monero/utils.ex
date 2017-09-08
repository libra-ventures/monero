defmodule Monero.Utils do
  @moduledoc false

  @doc "Utilit function to get value back. Useful as a fallback parser, for example"
  def identity(x), do: x
  def identity(x, _), do: x
end
