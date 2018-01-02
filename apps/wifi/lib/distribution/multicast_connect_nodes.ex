defmodule Distribution.MulticastConnectNodes do
  @moduledoc """
  Based heavily on https://dbeck.github.io/Scalesmall-W5-UDP-Multicast-Mixed-With-TCP/, and when I say based, I mean cargo culted.
  I don't know much about UDP multicast.

  * every second broadcasts to the UDP multicast group 224.1.1.1 on prot 49999 the name of this node
  * listens for those same broadcasts from other nodes. When one is found, which is not in the current node list, attempts to connect
  to the received node name at the received ip.

  This is highly insecure and as it will connect to any bugger. Also it needs to construct an atom from the id, so there's
  a symbol table attack here too.
  """
  use GenServer
  require Logger

  @ip {224, 1, 1, 1}
  @port 49_999
  @name __MODULE__
  @broadcast_inverval 30_000

  defstruct socket: nil

  @doc """
  Start. `my_name` is broadcast every second. The listening nodes
  will recreate the fully node name as `my_name`@[broadcaster's ip]
  """
  @spec start_link() :: {:ok, pid}
  def start_link() do
    GenServer.start_link(__MODULE__, {}, name: @name)
  end

  def init(_) do
    udp_options = [
      :binary,
      active:          10,
      add_membership:  {@ip, {0, 0, 0, 0}},
      multicast_if:    {0, 0, 0, 0},
      multicast_loop:  false,
      multicast_ttl:   4,
      reuseaddr:       true
    ]
    send(self(), :broadcast)
    {:ok, socket} = :gen_udp.open(@port, udp_options)
    {:ok, %__MODULE__{socket: socket}}
  end


  def handle_info({:udp, socket, _ip, _port, "iamnode:" <> node}, state) do
    # This is very vulnerable to atom table exhaustion attack. Do not use on
    # anything approaching a non-toy sytem.
    incoming_node = String.to_atom(node)
    unless incoming_node  in Node.list do
      node_connect(incoming_node)
    end
    :inet.setopts(socket, [active: 1])

    {:noreply, state}
  end

  def handle_info(msg = {:udp, socket, _ip, _port, _data}, state) do
    Logger.debug fn -> "Unexpected incomping udp: #{inspect(msg)}" end
    :inet.setopts(socket, [active: 1])
    {:noreply, state}
  end

  def handle_info(:broadcast, s = %{socket: socket}) do
    :gen_udp.send(socket, @ip, @port, "iamnode:#{Node.self()}")
    Process.send_after(self(), :broadcast, @broadcast_inverval)
    {:noreply, s}
  end

  def handle_info(_, s), do: {:noreply, s}

  defp node_connect(incoming_node) do
    unless incoming_node == Node.self() do
      case Node.connect(incoming_node) do
        true ->
          Logger.info fn ->"Yay! Connected to #{incoming_node}" end
        meh ->
          Logger.info fn -> "Spurious request: #{incoming_node} - #{inspect(meh)}" end
      end
    end
  end
end
