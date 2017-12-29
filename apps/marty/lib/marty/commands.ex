defmodule Marty.Commands do

  def enable_safeties do
    <<0x02, 0x1::size(16)-little, 0x1e>>
  end

  def hello(true) do
    <<0x02, 0x2::size(16)-little, 0x00, 0x01>>
  end
  def hello(false) do
    <<0x02, 0x2::size(16)-little, 0x00, 0x00>>
  end

  def celebrate(move_time) do
    <<0x02, 0x03::size(16)-little, 0x08, move_time::size(16)-little>>
  end

  def buzz_prevention(true), do: do_buzz_prevention(1)
  def buzz_prevention(false), do: do_buzz_prevention(0)

  defp do_buzz_prevention(enabled_byte) do
    <<0x02, 0x02::size(16)-little, 0x18, enabled_byte>>
  end

  def walk(steps, turn, move_time, step_length, side) do
    <<0x02, 0x07::size(16)-little, 0x03, steps, turn,
      move_time::size(16)-little, step_length::signed, side>>
  end

  def kick(side, twist, move_time) do
    <<0x02, 0x05::size(16)-little, 0x05, side, twist::signed, move_time::size(16)-little>>
  end

  def arms(r_angle, l_angle, move_time) do
    <<0x02, 0x05::size(16)-little, 0x0b, r_angle::signed, l_angle::signed, move_time::size(16)-little>>
  end

  def play_sound(freq_start, freq_end, duration) do
    <<0x02, 0x7::size(16)-little, 0x10, freq_start::size(16)-little, freq_end::size(16)-little, duration::size(16)-little>>
  end

  def circle_dance(side, move_time) do
    <<0x02, 0x04::size(16)-little, 0x1c, side, move_time::size(16)-little>>
  end

  def lifelike_behaviours(true), do: do_lifelike_behaviours(0x01)
  def lifelike_behaviours(false), do: do_lifelike_behaviours(0x00)

  def do_lifelike_behaviours(enabled) do
    <<0x02, 0x02::size(16)-little, 0x1d, enabled>>
  end
end
