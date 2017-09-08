defmodule MoneroTest do
  use ExUnit.Case
  doctest Monero

  test "has a request function" do
    assert 1 == :functions |> Monero.__info__() |> Keyword.fetch!(:request)
  end

  test "has a request! function" do
    assert 1 == :functions |> Monero.__info__() |> Keyword.fetch!(:request!)
  end
end
