defmodule MartyWeb.WalkCommandTest do
  use ExUnit.Case

  import MartyWeb.WalkCommand

  test "walk direction" do
    assert to_walk_command("forward", "medium", "3") == {:walk, [3, 0, 2_000, 50, 4]}
    assert to_walk_command("forward-left", "medium", "3") == {:walk, [3, 100, 2_000, 50, 4]}
    assert to_walk_command("forward-right", "medium", "3") == {:walk, [3, -100, 2_000, 50, 4]}

    assert to_walk_command("back", "medium", "3") == {:walk, [3, 0, 2_000, -50, 4]}
    assert to_walk_command("back-left", "medium", "3") == {:walk, [3, -100, 2_000, -50, 4]}
    assert to_walk_command("back-right", "medium", "3") == {:walk, [3, 100, 2_000, -50, 4]}
  end

  test "side-step direction" do
    assert to_walk_command("side-left", "medium", "3") == {:side_step, [0, 3, 2_000, 75]}
    assert to_walk_command("side-right", "medium", "3") == {:side_step, [1, 3, 2_000, 75]}
  end

  test "speed and steps" do
    assert to_walk_command("forward", "slow", "1") == {:walk, [1, 0, 5_250, 50, 4]}
    assert to_walk_command("forward", "slow", "2") == {:walk, [2, 0, 5_250, 50, 4]}
    assert to_walk_command("forward", "slow", "3") == {:walk, [3, 0, 3_500, 50, 4]}
    assert to_walk_command("forward", "medium", "3") == {:walk, [3, 0, 2_000, 50, 4]}
    assert to_walk_command("forward", "fast", "3") == {:walk, [3, 0, 1_500, 50, 4]}

    assert to_walk_command("forward", "fast", "6") == {:walk, [6, 0, 1_500, 50, 4]}
    assert to_walk_command("forward", "medium", "6") == {:walk, [6, 0, 2_000, 50, 4]}
    assert to_walk_command("forward", "slow", "6") == {:walk, [6, 0, 3_500, 50, 4]}

    assert to_walk_command("side-left", "fast", "4") == {:side_step, [0, 4, 1_500, 75]}
  end

  test "invalid steps" do
    assert to_walk_command("forward", "slow", "") == {:error, :invalid_steps}
  end
end
