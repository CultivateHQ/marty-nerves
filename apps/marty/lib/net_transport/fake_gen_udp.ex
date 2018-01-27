defmodule NetTransport.FakeGenUdp do
  @moduledoc """
  Use in place of `:gen_udp` in tests. Behaves like a spy.

  See `NetTransport.GenUdp`
  """

  use GenServer
  @behaviour NetTransport.GenUdp

  def open(_port, _ops) do
    GenServer.start_link(__MODULE__, {})
  end

  def recv(sock, 0, _timeout) do
    GenServer.call(sock, :recv)
  end

  def send(sock, address, port, packet) do
    GenServer.cast(sock, {:send, {address, port, packet}})
  end

  def clear_log(sock) do
    GenServer.cast(sock, :clear_log)
  end

  def log(sock) do
    GenServer.call(sock, :log)
  end

  def recv_this_next(sock, {address, port, packet}) do
    GenServer.cast(sock, {:recv_this_next, {address, port, packet}})
  end

  def init(_) do
    {:ok, %{log: [], recv_this_next: nil}}
  end

  def handle_cast({:send, msg}, s = %{log: log}) do
    {:noreply, %{s | log: [msg | log]}}
  end

  def handle_cast({:recv_this_next, packet}, s) do
    {:noreply, %{s | recv_this_next: packet}}
  end

  def handle_cast(:clear_log, s) do
    {:noreply, %{s | log: []}}
  end

  def handle_call(:recv, _, s = %{recv_this_next: nil}) do
    {:reply, {:error, :timeout}, s}
  end

  def handle_call(:recv, _, s = %{recv_this_next: packet}) do
    {:reply, {:ok, packet}, %{s | recv_this_next: nil}}
  end

  def handle_call(:log, _, s = %{log: log}) do
    {:reply, Enum.reverse(log), s}
  end
end
