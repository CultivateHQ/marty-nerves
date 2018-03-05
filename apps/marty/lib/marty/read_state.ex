defmodule Marty.ReadState do
  @moduledoc """
  Polls Marty for information, currently just the chatter channel and battery level.

  Updates battery in `Marty.State`. `Marty.Connection` is responsible for sending out chat
  updates.
  """
  use GenServer

  alias Marty.{Queries, Connection, State}

  @name __MODULE__
  @read_battery_interval 10_000
  @poll_for_chatter_interval 5_500
  @read_touch_sensor_interval 450
  @read_battery Queries.battery()

  @left_sensor 1
  @right_sensor 0

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    send(self(), :read_battery)
    send(self(), :poll_for_chatter)
    send(self(), :read_touch_sensors)
    {:ok, %{}}
  end

  def handle_info(:read_battery, s) do
    read_battery()
    Process.send_after(self(), :read_battery, @read_battery_interval)
    {:noreply, s}
  end

  def handle_info(:poll_for_chatter, s) do
    Connection.poll_for_chatter()
    Process.send_after(self(), :poll_for_chatter, @poll_for_chatter_interval)
    {:noreply, s}
  end

  def handle_info(:read_touch_sensors, s) do
    with {:ok, left} <- read_touch_sensor(@left_sensor),
         {:ok, right} <- read_touch_sensor(@right_sensor) do
      State.update_touch_sensors(
        Queries.interpret_gpio_pin_on_off(left),
        Queries.interpret_gpio_pin_on_off(right)
      )
    else
      _ -> nil
    end

    Process.send_after(self(), :read_touch_sensors, @read_touch_sensor_interval)
    {:noreply, s}
  end

  defp read_touch_sensor(pin) do
    pin
    |> Queries.read_gpio_pin()
    |> Connection.send_query()
  end

  defp read_battery() do
    case Connection.send_query(@read_battery) do
      {:ok, level} -> State.update_battery(level)
      _ -> nil
    end
  end
end
