defmodule Marty.CommandDefinitions do

  @definitions [
    {:hello, 0x0, [{:force, :boolean}]},
    {:celebrate, 0x08, [{:move_time, :uint16}]},
    {:buzz_prevention, 0x18, [{:enabled, :boolean}]},
    {:walk, 0x03, [{:steps, :uint8}, {:turn, :unit8}, {:move_time, :uint16}, {:step_length, :int8}, {:side, :uint8}]},
    {:kick, 0x05, [{:side, :int8}, {:twist, :int8}, {:move_time, :unit16}]},
    {:arms, 0x0b, [{:r_angle, :int8}, {:l_angle, :int8}, {:move_time, :uint16}]},
    {:play_sound, 0x10, [{:freq_start, :uint16}, {:freq_end, :uint16}, {:duration, :uint16}]},
    {:circle_dance, 0x1c, [{:side, :uint8}, {:move_time, :uint16}]},
  ]

  def call_commands do
    for {name, _, arg_definitions} <- @definitions do
      params = arg_definitions
      |> Enum.map(fn {a, _} -> Macro.var(a, nil) end)
      quote do
        def unquote(:"#{name}")(unquote_splicing(params)) do
          command = apply(Marty.Commands, unquote(name), unquote(params))
          Marty.Connection.send_command(command)
        end
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
