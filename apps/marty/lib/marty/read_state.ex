defmodule Marty.ReadState do
  use GenServer

  alias Marty.{Queries, Connection, State}

  @name __MODULE__
  @read_battery_interval 10_000
  @read_accelerometer_interval 250
  @read_battery Queries.battery
  @read_accelerometer_x Queries.accelerometer(:x)
  @read_accelerometer_y Queries.accelerometer(:y)
  @read_accelerometer_z Queries.accelerometer(:z)

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    send(self(), :read_battery)
    send(self(), :read_accelerometer)
    {:ok, %{}}
  end

  def handle_info(:read_battery, s) do
    read_battery()
    Process.send_after(self(), :read_battery, @read_battery_interval)
    {:noreply, s}
  end

  def handle_info(:read_accelerometer, s) do
    read_accelerometer()
    Process.send_after(self(), :read_accelerometer, @read_accelerometer_interval)
    {:noreply, s}
  end

  defp read_battery() do
    case Connection.send_query(@read_battery) do
      {:ok, level} -> State.update_battery(level)
      _ -> nil
    end
  end

  defp read_accelerometer() do
    with {:ok, x} <- Connection.send_query(@read_accelerometer_x),
         {:ok, y} <- Connection.send_query(@read_accelerometer_y),
         {:ok, z} <- Connection.send_query(@read_accelerometer_z) do
      State.update_accelerometer(x, y, z)
    else
      _ -> nil
    end
  end
end
