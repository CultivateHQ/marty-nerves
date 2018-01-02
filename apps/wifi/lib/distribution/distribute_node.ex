defmodule Distribution.DistributeNode do
  @moduledoc """
  Starts a node with the fully addressable name of `(node_name)@current_ip`

  It subscribes to the `Nerves.Udhcp` registry from `Nerves.Network` to receive notification of DHCP ipv4
  address assignment. When this happens:

  * the current node (if any) is stopped
  * the node is started with `node_name`@current_ip.

  Node name is set by by the config `wifi`, `node_name` and is (by default) the name of the app used to build
  the Nerves firmware.
  """

  use GenServer

  require Logger

  @name __MODULE__

  @doc """
  Start with the `node_name`. On receiving a dhcp ipv4 address it will
  bind to `node_name`@current_ip
  """
  @spec start_link(String.t) :: {:ok, pid}
  def start_link(node_name) do
    GenServer.start_link(__MODULE__, node_name, name: @name)
  end

  def init(node_name) do
    epmd_init()
    Registry.register(Nerves.Udhcpc, "wlan0", [])
    {:ok, node_name}
  end

  def handle_info({Nerves.Udhcpc, :bound, %{ipv4_address: address}}, node_name) do
    start_node(node_name, address)
    {:noreply, node_name}
  end
  def handle_info({Nerves.Udhcpc, _, _}, s),  do: {:noreply, s}


  defp start_node(node_name, address) do
    Node.stop
    full_node_name = "#{node_name}@#{address}" |> String.to_atom
    {:ok, _pid} = Node.start(full_node_name)
  end

  if Mix.env == :prod do
    defp epmd_init do
      {_, 0} = System.cmd("epmd", ["-daemon"])
      :ok
    end
  else
    defp epmd_init, do: :ok
  end
end
