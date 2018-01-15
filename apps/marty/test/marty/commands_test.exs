defmodule Marty.CommandsTest do
  use ExUnit.Case

  alias Marty.Commands

  describe "command properly formed for" do
    commands = [
      {:enable_safeties, []},
      {:hello, 0x0, [true]},
      {:hello, 0x0, [false]},
      {:celebrate, 0x08, [123]},
      {:buzz_prevention, 0x18, [true]},
      {:walk, 0x03, [3, 0, 5_000, 100, 4]},
      {:kick, 0x05, [1, 100, 5_000]},
      {:arms, 0x0b, [100, -100, 5_000]},
      {:play_sound, 0x10, [100, -100, 5_000]},
      {:circle_dance, 0x1c, [1, 5_000]},
      {:lifelike_behaviours, 0x1d, [true]},
      {:lifelike_behaviours, 0x1d, [false]},
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
