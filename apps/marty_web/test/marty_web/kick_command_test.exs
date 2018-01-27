defmodule MartyWeb.KickCommandTest do
  use ExUnit.Case
  doctest MartyWeb.KickCommand

  import MartyWeb.KickCommand

  test "foot" do
    assert {:kick, [0, 0, 1_500]} == to_kick("left", 0, "fast")
    assert {:kick, [1, 0, 1_500]} == to_kick("right", 0, "fast")
  end

  test "twist" do
    assert {:kick, [0, 0, 1_500]} == to_kick("left", 0, "fast")
    assert {:kick, [0, -100, 1_500]} == to_kick("left", -100, "fast")
  end

  test "speed" do
    assert {:kick, [0, 0, 1_500]} == to_kick("left", 0, "fast")
    assert {:kick, [0, 0, 3_000]} == to_kick("left", 0, "medium")
    assert {:kick, [0, 0, 5_000]} == to_kick("left", 0, "slow")
  end
end
