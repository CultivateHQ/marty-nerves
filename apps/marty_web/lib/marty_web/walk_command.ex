defmodule MartyWeb.WalkCommand do

  def to_walk_command(direction, speed, steps) when is_binary(steps)do
    case Integer.parse(steps) do
      {i, ""} -> to_walk_command(direction, speed, i)
      _ -> {:error, :invalid_steps}
    end
  end
  def to_walk_command(direction, speed, steps) do
    do_to_walk_command(String.split(direction, "-"), speed, steps)
  end

  defp do_to_walk_command(["side", direction], speed, steps) do
    {:side_step, [side_direction(direction), steps, duration(speed, steps), 75]}
  end

  defp do_to_walk_command(direction, speed, steps) do
    {:walk, [steps,
             turn(direction),
             duration(speed, steps),
             stride(direction),
             4]}
  end

  defp turn(["forward", "left"]), do: 100
  defp turn(["forward", "right"]), do: -100
  defp turn(["back", "right"]), do: 100
  defp turn(["back", "left"]), do: -100
  defp turn(_), do: 0

  defp side_direction("left"), do: 0
  defp side_direction("right"), do: 1

  defp duration(speed, steps) when steps < 3, do: round(do_duration(speed) * 1.5)
  defp duration(speed, _), do: do_duration(speed)

  defp do_duration("fast"), do: 1_500
  defp do_duration("medium"), do: 2_000
  defp do_duration("slow"), do: 3_500

  defp stride(["back", _]), do: -50
  defp stride(["back"]), do: -50
  defp stride(_), do: 50
end
