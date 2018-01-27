defmodule NetTransport.RealGenTcp do
  @moduledoc """
  Proxies `:gen_tcp` when it is replaceable for testing. See `NetTransport.GenTcp`

  `:gen_tcp` is not used directly, unlike `:gen_udp`, because `send/2` clashes with `Kernel.send/2`.
  `tcp_send/2` is used instead.
  """

  @behaviour NetTransport.GenTcp

  def connect(address, port, timeout) do
    :gen_tcp.connect(address, port, [], timeout)
  end

  defdelegate tcp_send(socket, data), to: :gen_tcp, as: :send
  defdelegate close(socket), to: :gen_tcp
end
