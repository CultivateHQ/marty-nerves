defmodule Marty.Queries do
  def battery do
    <<0x01, 0x01, 0x00>>
  end

  def get_chatter do
    <<0x01, 0x05, 0x00>>
  end

  def read_chatter(chatter) when length(chatter) < 5 do
    :not_chatter
  end

  def read_chatter([_, _, _, _ | zero_terminated_msg]) do
    binary_zero_terminated = IO.chardata_to_string(zero_terminated_msg)

    case String.split_at(binary_zero_terminated, length(zero_terminated_msg) - 1) do
      {msg, <<0>>} ->
        check_chatter_printable(msg)

      _ ->
        :not_chatter
    end
  end

  defp check_chatter_printable(msg) do
    if String.printable?(msg) do
      {:ok, msg}
    else
      :not_chatter
    end
  end

  def accelerometer(axis) when axis in [:x, :y, :z] do
    axis_code =
      case axis do
        :x -> 0x00
        :y -> 0x01
        :z -> 0x02
      end

    <<0x01, 0x02, axis_code>>
  end

  def decode_result([a, b, c, d]) do
    <<res::float-little-size(32)>> = <<a, b, c, d>>
    res
  end
end
