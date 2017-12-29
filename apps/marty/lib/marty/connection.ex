defmodule Marty.Connection do
  use GenServer
  alias Marty.Commands
  require Logger


  @name __MODULE__

  @marty_ip {10, 0, 0, 49}
  @marty_port 24
  @connect_timeout 5_000
  @retry_interval 2_000


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
    case :gen_tcp.connect(@marty_ip, @marty_port, [], @connect_timeout) do
      {:ok, sock} ->
        Logger.debug "Connected to Marty"
        :ok = :gen_tcp.send(sock, Commands.enable_safeties())
        :ok = :gen_tcp.send(sock, Commands.lifelike_behaviours(true))
        {:noreply, %{s | sock: sock}}
      err ->
        Logger.debug fn -> "Failed to connect to Marty: #{inspect(err)}" end
        Process.send_after(self(), :connect, @retry_interval)
        {:noreply, s}
    end
  end

  def handle_call({:send_command, _}, _, s = %{sock: nil}) do
    {:reply, {:error, :not_connected}, s}
  end

  def handle_call({:send_command, command}, _, s = %{sock: sock}) do
    result = :gen_tcp.send(sock, command)
    {:reply, result, s}
  end
end
