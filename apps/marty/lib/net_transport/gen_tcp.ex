defmodule NetTransport.GenTcp do
  def impl do
    Application.get_env(:marty, :gen_tcp_impl, NetTransport.RealGenTcp)
  end

  @callback connect(:inet.socket_address, :inet.port_number, timeout) :: any
  @callback tcp_send(any, iodata) :: :ok | {:error, any}
  @callback close(any) :: :ok
end
