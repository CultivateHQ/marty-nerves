defmodule Marty do

  alias Marty.{Commands, Connection}

  def hello(force \\ true) do
    Connection.send_command(Commands.hello(force))
  end

  def celebrate(move_time) do
    Connection.send_command(Commands.celebrate(move_time))
  end

  def buzz_prevention(enable \\ true) do
    Connection.send_command(Commands.buzz_prevention(enable))
  end

  def walk(steps, turn, move_time, step_length, side) do
    Connection.send_command(Commands.walk(steps, turn, move_time, step_length, side))
  end

  def kick(side, twist, move_time) do
    Connection.send_command(Commands.kick(side, twist, move_time))
  end

  def arms(r_angle, l_angle, move_time) do
    Connection.send_command(Commands.arms(r_angle, l_angle, move_time))
  end

  def play_sound(freq_start, freq_end, duration) do
    Connection.send_command(Commands.play_sound(freq_start, freq_end, duration))
  end

  def circle_dance(side, move_time) do
    Connection.send_command(Commands.circle_dance(side, move_time))
  end
end
