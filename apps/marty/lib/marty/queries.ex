defmodule Marty.Queries do

  def battery do
    <<0x01, 0x01, 0x00>>
  end

  def accelerometer(axis) when axis in [:x, :y, :z] do
    axis_code = case(axis) do
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
