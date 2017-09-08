defmodule ExMoneroTest do
  use ExUnit.Case
  doctest ExMonero

  test "has a request function" do
    assert 1 == ExMonero.__info__(:functions) |> Keyword.fetch!(:request)
  end

  test "has a request! function" do
    assert 1 == ExMonero.__info__(:functions) |> Keyword.fetch!(:request!)
  end
end
