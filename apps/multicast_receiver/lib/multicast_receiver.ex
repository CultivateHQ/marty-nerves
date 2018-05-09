defmodule MulticastReceiver do

  use GenServer

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, opts)
  end

  def init (:ok) do
    udp_options = [
      :binary,
      active:          10,
      add_membership:  { {224,1,1,1}, {0,0,0,0} },
      multicast_if:    {0,0,0,0},
      multicast_loop:  false,
      multicast_ttl:   4,
      reuseaddr:       true
    ]

    {:ok, _socket} = :gen_udp.open(49999, udp_options)
  end

  def handle_info({:udp, socket, ip, port, data}, state)
  do
    # when we popped one message we allow one more to be buffered
    :inet.setopts(socket, [active: 1])
    IO.inspect [ip, port, data]
    {:noreply, state}
  end
end
