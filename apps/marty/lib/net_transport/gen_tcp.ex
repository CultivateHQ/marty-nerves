defmodule NetTransport.GenTcp do
  @moduledoc """
  Enables calls to `gen_tcp` to be faked in tests. Note that `send/2` is not used
  as the clash with `Kernel.send/2` causes issues when faking. We use `tcp_send/2` instead.
  """

  def gen_tcp do
    Application.get_env(:marty, :gen_tcp_impl, NetTransport.RealGenTcp)
  end

  @callback connect(:inet.socket_address(), :inet.port_number(), timeout) :: any
  @callback tcp_send(any, iodata) :: :ok | {:error, any}
  @callback close(any) :: :ok
end
