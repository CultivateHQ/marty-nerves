defmodule MartyWeb.FunCommandsTest do
  use ExUnit.Case

  import MartyWeb.FunCommands

  test "celebrate" do
    assert to_celebrate("fast") == {:celebrate, [1_000]}
    assert to_celebrate("medium") == {:celebrate, [2_000]}
    assert to_celebrate("slow") == {:celebrate, [5_000]}
  end

  test "tap_foot" do
    assert to_tap_foot("left") == {:tap_foot, [0]}
    assert to_tap_foot("right") == {:tap_foot, [1]}
  end

  test "cirecle_dance" do
    assert to_circle_dance("left", "slow") == {:circle_dance, [0, 6_000]}
    assert to_circle_dance("left", "medium") == {:circle_dance, [0, 3_000]}
    assert to_circle_dance("left", "fast") == {:circle_dance, [0, 1_500]}
    assert to_circle_dance("right", "fast") == {:circle_dance, [1, 1_500]}
  end
end
