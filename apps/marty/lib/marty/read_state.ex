defmodule Marty.ReadState do
  use GenServer

  alias Marty.{Queries, Connection, State}

  @name __MODULE__
  @read_battery_interval 10_000
  @poll_for_chatter_interval 5_000
  @read_battery Queries.battery()

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    send(self(), :read_battery)
    send(self(), :poll_for_chatter)
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

  defp read_battery() do
    case Connection.send_query(@read_battery) do
      {:ok, level} -> State.update_battery(level)
      _ -> nil
    end
  end
end
