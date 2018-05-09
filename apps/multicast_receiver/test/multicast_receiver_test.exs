defmodule MulticastReceiverTest do
  use ExUnit.Case
  doctest MulticastReceiver

  test "greets the world" do
    assert MulticastReceiver.hello() == :world
  end
end
