defmodule Marty.CommandsTest do
  use ExUnit.Case

  alias Marty.Commands

  describe "command properly formed for" do
    commands = [
      {:hello, 0x0, [true]},
      {:hello, 0x0, [false]},
      {:lean, 0x02, [1, 100, 245]},
      {:walk, 0x03, [3, 0, 5_000, 100, 4]},
      {:kick, 0x05, [1, 100, 5_000]},
      {:celebrate, 0x08, [123]},
      {:tap_foot, 0x0A, [1]},
      {:arms, 0x0b, [100, -100, 5_000]},
      {:side_step, 0x0E, [1, 3, 4, 100]},
      {:stand_straight, 0x0F, [2_000]},
      {:play_sound, 0x10, [100, -100, 5_000]},
      {:stop, 0x11, [2]},
      {:move_joint, 0x12, [1, 25, 100]},
      {:fall_protection, 0x15, [true]},
      {:motor_protection, 0x16, [true]},
      {:low_battery_cutoff, 0x17, [true]},
      {:buzz_prevention, 0x18, [true]},
      {:circle_dance, 0x1c, [1, 5_000]},
      {:lifelike_behaviours, 0x1d, [true]},
      {:enable_safeties, 0x1e, []},
    ]

    for {f, opcode, a} <- commands do
      test "#{f} with #{inspect(a)}" do
        assert command = <<command_code::size(8), reported_length::size(16)-little, opcode::size(8), _::binary>> =
          apply(Commands, unquote(f), unquote(a))
        assert command_code == 0x02
        assert opcode == unquote(opcode)
        assert reported_length == byte_size(command) - 3
      end
    end
  end
end
