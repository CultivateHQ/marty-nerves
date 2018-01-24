defmodule Camera.PicamSettings do
  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    send(self(), :set)
    {:ok, %{}}
  end

  def handle_info(:set, s) do
    Picam.set_size(644, 484)
    {:noreply, s}
  end
end
