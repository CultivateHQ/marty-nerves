defmodule NetTransport.RealGenTcp do
  @behaviour NetTransport.GenTcp

  def connect(address, port, timeout) do
    :gen_tcp.connect(address, port, [], timeout)
  end

  defdelegate tcp_send(socket, data), to: :gen_tcp, as: :send
  defdelegate close(socket), to: :gen_tcp
end
