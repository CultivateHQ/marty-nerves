defmodule Marty.CommandDefinitions do

  @definitions [
    {:hello, 0x0, [{:force, :boolean}]},
    {:celebrate, 0x08, [{:move_time, :uint16}]},
    {:buzz_prevention, 0x18, [{:enabled, :boolean}]},
    {:walk, 0x03, [{:steps, :uint8}, {:turn, :uint8}, {:move_time, :uint16}, {:step_length, :int8}, {:side, :uint8}]},
    {:kick, 0x05, [{:side, :int8}, {:twist, :int8}, {:move_time, :uint16}]},
    {:arms, 0x0b, [{:r_angle, :int8}, {:l_angle, :int8}, {:move_time, :uint16}]},
    {:play_sound, 0x10, [{:freq_start, :uint16}, {:freq_end, :uint16}, {:duration, :uint16}]},
    {:circle_dance, 0x1c, [{:side, :uint8}, {:move_time, :uint16}]},
    {:enable_safeties, 0x1e, []},
    {:lifelike_behaviours, 0x1d, [{:force, :boolean}]},
  ]

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end

  def define_commands do
    define_command_methods = Enum.map(@definitions, & make_command(&1))

    helpers = quote do
      def convert_bool(true), do: 1
      def convert_bool(false), do: 0
    end

    [helpers | define_command_methods]
  end

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

  defp calculate_command_size(args) do
    args
    |> Enum.reduce(1, fn {_, type}, sum -> sum + arg_size(type) end)
  end

  defp arg_size(:uint16), do: 2
  defp arg_size(:int8), do: 1
  defp arg_size(:uint8), do: 1
  defp arg_size(:boolean), do: 1

  defp quoted_command_param({name, :boolean}) do
    "convert_bool(#{name})::size(8)"
  end
  defp quoted_command_param({name, type}) do
    "#{name}::#{command_param_type(type)}"
  end

  defp command_param_type(:uint16), do: "size(16)-little"
  defp command_param_type(:int8), do: "size(8)"
  defp command_param_type(:uint8), do: "size(8)"

  defp command_params(args) do
    args
    |> Enum.map(&quoted_command_param/1)
    |> Enum.join(",")
  end

  defp make_command({name, opcode, args}) do
    function_params = args
    |> Enum.map(fn {a, _} -> Macro.var(a, nil) end)

    size = calculate_command_size(args)

    command = "<<0x2,#{size}::size(16)-little,#{opcode},#{command_params(args)}>>"
    quoted_command = Code.string_to_quoted!(command)


    quote do
      def unquote(name)(unquote_splicing(function_params)) do
        # <<0x02, unquote(size)::size(16)-little, unquote(opcode), unquote(command_params)>>
        unquote(quoted_command)
      end
    end
  end
end
