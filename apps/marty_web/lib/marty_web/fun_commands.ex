defmodule MartyWeb.FunCommands do
  @moduledoc """
  Decodes tap, celebrate, and circle dance commands from the UI to
  functiona and argument calls to the `Marty` module
  """

  def to_celebrate(speed) do
    move_time =
      case speed do
        "fast" -> 1_000
        "medium" -> 2_000
        "slow" -> 5_000
      end

    {:celebrate, [move_time]}
  end

  def to_tap_foot(side) do
    {:tap_foot, [side_code(side)]}
  end

  def to_circle_dance(side, speed) do
    move_time =
      case speed do
        "fast" -> 1_500
        "medium" -> 3_000
        "slow" -> 6_000
      end

    {:circle_dance, [side_code(side), move_time]}
  end

  defp side_code("left"), do: 0
  defp side_code("right"), do: 1
end
