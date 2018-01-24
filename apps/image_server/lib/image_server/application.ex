defmodule ImageServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    children = [
      {Plug.Adapters.Cowboy, scheme: :http, plug: __MODULE__, options: cowboy_options()},
    ]

    opts = [strategy: :one_for_one, name: ImageServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def dispatch_spec do
    [
      {:_, [
          {"/", ImageServer.ImagesFromCameraWebsocketHandler, []},
        ]
      }
    ]
  end

  defp cowboy_options do
    :image_server
    |> Application.fetch_env!(:cowboy_options)
    |> Keyword.put(:dispatch, dispatch_spec())
  end
end
