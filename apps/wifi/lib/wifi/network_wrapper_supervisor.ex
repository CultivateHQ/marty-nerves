defmodule Wifi.NetworkWrapperSupervisor do
  @moduledoc false

  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    children = [
      worker(Wifi.NetworkWrapper, [Wifi.settings_file()])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
