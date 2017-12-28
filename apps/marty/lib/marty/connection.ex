defmodule Marty.Connection do
  use GenServer
  alias Marty.Commands

  @name __MODULE__

  @marty_ip {10, 0, 0, 49}
  @marty_port 24
  @connect_timeout 5_000

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def send_command(command) do
    GenServer.call(@name, {:send_command, command})
  end


  def init(_) do
    send(self(), :connect)
    {:ok, %{sock: nil}}
  end

  def handle_info(:connect, s) do
    {:ok, sock} = :gen_tcp.connect(@marty_ip, @marty_port, [], @connect_timeout)
    :ok = :gen_tcp.send(sock, Commands.enable_safeties())
    {:noreply, %{s | sock: sock}}
  end


  def handle_call({:send_command, command}, _, s = %{sock: sock}) when not is_nil(sock) do
    result = :gen_tcp.send(sock, command)
    {:reply, result, s}
  end
end
