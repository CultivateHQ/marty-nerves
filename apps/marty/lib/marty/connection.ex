defmodule Marty.Connection do
  use GenServer
  alias Marty.{Commands, Queries, State}
  require Logger

  import NetTransport.GenTcp, only: [gen_tcp: 0]

  @name __MODULE__

  @marty_ip {10, 0, 0, 49}
  @marty_port 24

  @connect_timeout 1_000
  @retry_interval 5_000
  @query_timeout 500


  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def send_command(command) do
    GenServer.call(@name, {:send_command, command})
  end

  def send_query(query) do
    GenServer.call(@name, {:send_query, query})
  end

  def poll_for_chatter do
    GenServer.cast(@name, :poll_for_chatter)
  end

  def init(_) do
    State.disconnected()
    send(self(), :connect)
    {:ok, %{sock: nil}}
  end

  def handle_info(:connect, s) do
    case gen_tcp().connect(@marty_ip, @marty_port, @connect_timeout) do
      {:ok, sock} ->
        Logger.debug "Connected to Marty"
        gen_tcp().tcp_send(sock, Commands.enable_safeties())
        gen_tcp().tcp_send(sock, Commands.lifelike_behaviours(true))
        State.connected()
        {:noreply, %{s | sock: sock}}
      err ->
        Logger.debug fn -> "Failed to connect to Marty: #{inspect(err)}" end
        Process.send_after(self(), :connect, @retry_interval)
        {:noreply, s}
    end
  end

  def handle_info({:tcp, _, candidate_chat_response}, s) do
    case Queries.read_chatter(candidate_chat_response) do
      {:ok, msg} ->
        State.chat_message_received(msg)
      e ->
        IO.inspect e
        nil
    end
    {:noreply, s}
  end

  def handle_info(msg, s) do
    Logger.debug fn -> "Unexpected message:  #{inspect msg}" end
    {:noreply, s}
  end

  def handle_call({:send_command, _}, _, s = %{sock: nil}) do
    {:reply, {:error, :not_connected}, s}
  end

  def handle_call({:send_query, _}, _, s = %{sock: nil}) do
    {:reply, {:error, :not_connected}, s}
  end

  def handle_call({:send_command, command}, _, s = %{sock: sock}) do
    result = gen_tcp().tcp_send(sock, command)
    {:reply, result, s}
  end

  def handle_call({:send_query, query}, _, s = %{sock: sock}) do
    gen_tcp().tcp_send(sock, query)
    receive do
      {:tcp, ^sock, res} when length(res) == 4 ->
        {:reply, {:ok, Queries.decode_result(res)}, s}
    after
      @query_timeout ->
        Process.send_after(self(), :connect, @retry_interval)
        disconnect(sock)
        {:reply, {:error, :timeout}, %{s | sock: nil}}
    end
  end

  def handle_cast(:poll_for_chatter, s = %{sock: nil}) do
    {:noreply, s}
  end

  def handle_cast(:poll_for_chatter, s = %{sock: sock}) do
    gen_tcp().tcp_send(sock, Queries.get_chatter)
    {:noreply, s}
  end

  defp disconnect(sock) do
    State.disconnected()
    gen_tcp().close(sock)
  end
end
