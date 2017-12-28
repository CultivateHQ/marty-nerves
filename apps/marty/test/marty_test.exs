defmodule MartyTest do
  use ExUnit.Case
  doctest Marty

  test "greets the world" do
    assert Marty.hello() == :world
  end
end
