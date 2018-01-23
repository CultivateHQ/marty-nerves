defmodule Wifi.Application do
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  @mix_env Mix.env

  def start(_type, _args) do
    opts = [strategy: :one_for_one, name: Wifi.Supervisor]
    Supervisor.start_link(children(@mix_env), opts)
  end

  defp ntp_servers do
    Application.fetch_env!(:wifi, :ntp_servers)
  end

  defp node_name do
    {:ok, hostname} = :inet.gethostname()
    hostname
  end

  defp children(:test), do: []
  defp children(_) do
    [
      supervisor(Wifi.NetworkWrapperSupervisor, []),
      worker(Wifi.Ntp, [ntp_servers()]),
      worker(Distribution.DistributeNode, [node_name()]),
      worker(Distribution.MulticastConnectNodes, []),
    ]
  end
end
