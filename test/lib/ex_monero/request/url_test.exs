defmodule ExMonero.Request.UrlTest do
  use ExUnit.Case, async: true
  alias ExMonero.Request.Url

  setup do
    query = %{
      path: "/path",
    }
    config = %{
      url: "http://127.0.0.1:18081"
    }

    {:ok, %{query: query, config: config}}
  end

  test "it build urls for query operation", %{query: query, config: config} do
    assert Url.build(query, config) == "http://127.0.0.1:18081/path"
  end

  test "it cleans up excessive slashes in the path", %{query: query, config: config} do
    query = query |> Map.put(:path, "//path///with/too/many//slashes//")
    assert Url.build(query, config) == "http://127.0.0.1:18081/path/with/too/many/slashes/"
  end
end
