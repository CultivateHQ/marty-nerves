defmodule ImageServerTest do
  use ExUnit.Case
  doctest ImageServer

  test "greets the world" do
    assert ImageServer.hello() == :world
  end
end
