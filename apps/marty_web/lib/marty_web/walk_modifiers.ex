defmodule MartyWeb.WalkModifiers do

  def to_params(direction, speed, steps) when is_binary(steps)do
    case Integer.parse(steps) do
      {i, ""} -> to_params(direction, speed, i)
      _ -> {:error, :invalid_steps}
    end
  end
  def to_params(direction, speed, steps) do
    do_to_params(String.split(direction, "-"), speed, steps)
  end

  defp do_to_params(["side", direction], speed, steps) do
    {:side_step, [side_direction(direction), steps, duration(speed, steps), 100]}
  end

  defp do_to_params(direction, speed, steps) do
    {:walk, [steps,
             turn(direction),
             duration(speed, steps),
             100,
             4]}
  end

  defp turn([_, "left"]), do: 100
  defp turn([_, "right"]), do: -100
  defp turn(_), do: 0

  defp side_direction("left"), do: 0
  defp side_direction("right"), do: 1

  defp duration("fast", steps), do: steps * 500
  defp duration("medium", steps), do: steps * 1_000
  defp duration(_, steps), do: steps * 2_000
end
