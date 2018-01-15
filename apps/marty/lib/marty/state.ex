defmodule Marty.State do
  @moduledoc """
  Records and broadcasts what we know about Marty.
  """

  use GenServer

  @name __MODULE__

  defmodule Accelerometer do
    defstruct x: nil, y: nil, z: nil
    @type t :: %__MODULE__{x: float, y: float, z: float}
  end

  defstruct connected?: false, battery: nil, accelerometer: nil
  @type t :: %__MODULE__{connected?: boolean, battery: float, accelerometer: Accelerometer.t}

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

  def update_accelerometer(x, y, z) do
    GenServer.cast(@name, {:update_accelerometer, {x, y, z}})
  end

  def accelerometer do
    GenServer.call(@name, :accelerometer)
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

  def handle_cast({:update_accelerometer, {x, y, z}}, s) do
    state_changed()
    {:noreply, %{s | accelerometer: %Accelerometer{x: x, y: y,z: z}}}
  end

  def handle_call(:connected?, _, s) do
    state_changed()
    {:reply, s.connected?, s}
  end

  def handle_call(:battery, _, s) do
    {:reply, s.battery, s}
  end

  def handle_call(:accelerometer, _, s) do
    {:reply, s.accelerometer, s}
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
