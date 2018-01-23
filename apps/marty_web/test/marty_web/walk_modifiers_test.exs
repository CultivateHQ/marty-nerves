defmodule MartyWeb.WalkModifiersTest do
  use ExUnit.Case

  import MartyWeb.WalkModifiers

  test "walk direction" do
    assert to_params("forward", "medium", "3") == {:walk, [3, 0, 3_000, 100, 4]}
    assert to_params("forward-left", "medium", "3") == {:walk, [3, 100, 3_000, 100, 4]}
    assert to_params("forward-right", "medium", "3") == {:walk, [3, -100, 3_000, 100, 4]}


    assert to_params("back", "medium", "3") == {:walk, [3, 0, 3_000, -100, 4]}
    assert to_params("back-left", "medium", "3") == {:walk, [3, 100, 3_000, -100, 4]}
    assert to_params("back-right", "medium", "3") == {:walk, [3, -100, 3_000, -100, 4]}
  end

  test "side-step direction" do
    assert to_params("side-left", "medium", "3") == {:side_step, [0, 3, 3_000, 100]}
    assert to_params("side-right", "medium", "3") == {:side_step, [1, 3, 3_000, 100]}
  end

  test "speed and steps" do
    assert to_params("forward", "slow", "3") == {:walk, [3, 0, 6_000, 100, 4]}
    assert to_params("forward", "medium", "3") == {:walk, [3, 0, 3_000, 100, 4]}
    assert to_params("forward", "fast", "3") == {:walk, [3, 0, 1_500, 100, 4]}

    assert to_params("forward", "fast", "6") == {:walk, [6, 0, 3_000, 100, 4]}
    assert to_params("forward", "medium", "6") == {:walk, [6, 0, 6_000, 100, 4]}
    assert to_params("forward", "slow", "6") == {:walk, [6, 0, 12_000, 100, 4]}

    assert to_params("side-left", "fast", "4") == {:side_step, [0, 4, 2_000, 100]}
  end

  test "invalid steps" do
    assert to_params("forward", "slow", "") == {:error, :invalid_steps}
  end
end
