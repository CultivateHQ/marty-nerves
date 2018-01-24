defmodule Marty.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :duplicate, name: Marty.Event.Registry},
      Marty.State,
      Marty.Discover,
      Marty.Connection,
      Marty.ReadState
    ]

    opts = [strategy: :one_for_one, name: Marty.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
