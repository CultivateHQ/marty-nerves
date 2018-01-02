defmodule Wifi.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false
    children = [
      supervisor(Wifi.NetworkWrapperSupervisor, []),
      worker(Wifi.Ntp, [ntp_servers()]),
      worker(Distribution.DistributeNode, [node_name()]),
      worker(Distribution.MulticastConnectNodes, []),
    ]

    opts = [strategy: :one_for_one, name: Wifi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp ntp_servers do
    Application.fetch_env!(:wifi, :ntp_servers)
  end

  defp node_name do
    {:ok, hostname} = :inet.gethostname()
    hostname
  end
end
