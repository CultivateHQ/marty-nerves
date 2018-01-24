defmodule Marty.Discover do
  use GenServer
  require Logger

  import NetTransport.GenUdp, only: [gen_udp: 0]

  alias Marty.{Events, State}

  @ip {224, 0, 0, 1}
  @port 4_000
  @name __MODULE__

  @poll_interval 3_000

  defstruct socket: nil, marty_ip: nil

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: @name)
  end

  def subscribe do
    Events.subscribe(:marty_discover)
  end

  def init(_) do
    udp_options = [
      :binary,
      active: false,
      add_membership: {@ip, {0, 0, 0, 0}},
      multicast_if: {0, 0, 0, 0},
      multicast_loop: false,
      multicast_ttl: 4,
      reuseaddr: true
    ]

    send(self(), :poll)
    {:ok, socket} = gen_udp().open(@port, udp_options)
    {:ok, %__MODULE__{socket: socket}}
  end

  def handle_info(:poll, s = %{socket: sock}) do
    unless State.connected?(), do: poll(sock)
    Process.send_after(self(), :poll, @poll_interval)
    {:noreply, s}
  end

  def handle_info(msg, s) do
    Logger.debug(fn -> "Received: #{inspect(msg)}" end)
    {:noreply, s}
  end

  defp poll(sock) do
    gen_udp().send(sock, @ip, @port, "AA")

    case gen_udp().recv(sock, 0, 1_000) do
      {:ok, {marty_ip, _, marty_name}} ->
        Events.broadcast(:marty_discover, {:marty_discover, {marty_ip, marty_name}})

      {:error, reason} ->
        Logger.debug(fn -> inspect({:marty_discover_err, reason}) end)
    end
  end
end
