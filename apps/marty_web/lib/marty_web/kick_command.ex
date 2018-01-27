defmodule MartyWeb.KickCommand do
  @moduledoc """
  Translates kick input from the UI into Kick parameters to method call
  function and arguments on the  `Marty` module.

  eg

  iex> MartyWeb.KickCommand.to_kick("right", "0", "fast")
  {:kick, [1, 0, 1500]}
  """

  def to_kick(foot, twist, speed) when is_binary(twist) do
    to_kick(foot, to_int(twist), speed)
  end

  def to_kick(foot, twist, speed) do
    {:kick, [foot_code(foot), twist, speed_to_move_time(speed)]}
  end

  defp foot_code("left"), do: 0
  defp foot_code(_), do: 1

  defp speed_to_move_time("fast"), do: 1_500
  defp speed_to_move_time("medium"), do: 3_000
  defp speed_to_move_time(_), do: 5_000

  defp to_int(binary_twist) do
    case Integer.parse(binary_twist) do
      {i, ""} -> i
      _ -> 0
    end
  end
end
