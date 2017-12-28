defmodule Marty.Commands do

  def enable_safeties do
    <<0x02, 0x1::size(16)-little, 0x1e>>
  end

  def hello(force \\ false)
  def hello(true) do
    <<0x02, 0x2::size(16)-little, 0x00, 0x01>>
  end
  def hello(false) do
    <<0x02, 0x1::size(16)-little, 0x00>>
  end

  def celebrate(move_time) do
    <<0x02, 0x03::size(16)-little, 0x08, move_time::size(16)-little>>
  end
end
