defmodule Marty.State do
  @moduledoc """
  Records and broadcasts what we know about Marty.
  """

  use GenServer

  @name __MODULE__

  defstruct connected?: false, battery: nil
  @type t :: %__MODULE__{connected?: boolean, battery: float}

  def start_link(_) do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    {:ok, %__MODULE__{}}
  end

  def subscribe() do
    Registry.register(Marty.State.Registry, :marty_state, [])
  end

  def connected do
    GenServer.cast(@name, :connected)
  end

  def update_battery(level) do
    GenServer.cast(@name, {:update_battery, level})
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
    {:noreply, %{s |connected?: true}}
  end

  def handle_cast(:disconnected, _s) do
    state_changed()
    {:noreply, %__MODULE__{}}
  end

  def handle_cast({:update_battery, level}, s) do
    state_changed()
    {:noreply, %{s | battery: level}}
  end

  def handle_call(:connected?, _, s) do
    state_changed()
    {:reply, s.connected?, s}
  end

  def handle_call(:battery, _, s) do
    {:reply, s.battery, s}
  end

  def handle_info(:state_changed, s) do
    Registry.dispatch(Marty.State.Registry, :marty_state, fn entries ->
      for {pid, _} <- entries, do: send(pid, {:marty_state, s})
    end)
    {:noreply, s}
  end

  defp state_changed() do
    send(self(), :state_changed)
  end
end
