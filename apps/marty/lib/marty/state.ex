defmodule Marty.State do
  @moduledoc """
  Records and broadcasts what we know about Marty.
  """

  use GenServer

  alias Marty.Events

  @name __MODULE__

  defstruct connected?: false, battery: nil, touch_sensors: %{left: false, right: false}

  @type t :: %__MODULE__{
          connected?: boolean,
          battery: float,
          touch_sensors: map()
        }

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def subscribe() do
    Events.subscribe(:marty_state)
  end

  def connected do
    GenServer.cast(@name, :connected)
  end

  def update_battery(level) do
    GenServer.cast(@name, {:update_battery, level})
  end

  def update_touch_sensors(left, right) do
    GenServer.cast(@name, {:update_touch_sensors, %{left: left, right: right}})
  end

  def chat_message_received(msg) do
    GenServer.cast(@name, {:chat_message_received, msg})
  end

  def battery do
    GenServer.call(@name, :battery)
  end

  def disconnected do
    GenServer.cast(@name, :disconnected)
  end

  def connected? do
    GenServer.call(@name, :connected?)
  end

  def handle_cast(:connected, s) do
    state_changed()
    {:noreply, %{s | connected?: true}}
  end

  def handle_cast(:disconnected, _s) do
    state_changed()
    {:noreply, %__MODULE__{}}
  end

  def handle_cast({:update_battery, level}, s) do
    state_changed()
    {:noreply, %{s | battery: level}}
  end

  def handle_cast({:chat_message_received, msg}, s) do
    Events.broadcast(:marty_state, {:marty_chat, msg})
    {:noreply, s}
  end

  def handle_cast({:update_touch_sensors, new_sensor_state}, s = %{touch_sensors: sensor_state})
      when new_sensor_state != sensor_state do
    state_changed()
    {:noreply, %{s | touch_sensors: new_sensor_state}}
  end

  def handle_cast({:update_touch_sensors, _}, s) do
    {:noreply, s}
  end

  def handle_call(:connected?, _, s) do
    state_changed()
    {:reply, s.connected?, s}
  end

  def handle_call(:battery, _, s) do
    {:reply, s.battery, s}
  end

  def handle_info(:state_changed, s) do
    Events.broadcast(:marty_state, {:marty_state, s})
    {:noreply, s}
  end

  defp state_changed() do
    send(self(), :state_changed)
  end
end
