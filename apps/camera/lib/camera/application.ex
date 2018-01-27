defmodule Camera.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(Camera.Cam.impl(), []),
      worker(Camera.PicamSettings, [])
    ]

    opts = [strategy: :one_for_one, name: Camera.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
