defmodule NetTransport.GenUdp do
  @moduledoc """
  Enables `:gen_udp` to be replaced in tests.

  Call `gen_udp/0` to return the appropriate implementation for your environment.
  """

  def gen_udp do
    Application.get_env(:marty, :gen_udp_impl, :gen_udp)
  end

  @callback open(:inet.port_number(), list()) :: any
  @callback send(any, :inet.ip_address(), :inet.port_number(), binary) :: :ok | {:error, any}
  @callback recv(any, 0, integer) ::
              {:ok, :inet.ip_address(), :inet.port_number(), binary} | {:error, any}
end
