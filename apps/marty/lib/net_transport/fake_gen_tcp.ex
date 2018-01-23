defmodule NetTransport.FakeGenTcp do
  use GenServer
  @behaviour NetTransport.GenTcp

  defstruct client: nil, log: []
  @type t :: %__MODULE__{client: pid, log: []}

  @chat String.to_charlist("aaaaHello matey.") ++ [0]

  def connect(_ip, _socket, _timeout) do
    GenServer.start(__MODULE__, self())
  end

  def close(pid) do
    GenServer.cast(pid, :close)
  end

  def tcp_send(pid, cmd = <<0x02, _::binary>>) do
    GenServer.cast(pid, {:send_command, cmd})
  end

  def tcp_send(pid, <<0x01, 0x05, _>>) do
    GenServer.cast(pid, :get_chat)
  end

  def tcp_send(pid, <<0x01, opcode, arg>>) do
    GenServer.cast(pid, {:get, opcode, arg})
  end

  def clear_log(pid) do
    GenServer.cast(pid, :clear_log)
  end

  def log(pid) do
    GenServer.call(pid, :log)
  end

  def connection_socket do
    %{sock: sock} = :sys.get_state(Marty.Connection)
    sock
  end

  def init(client) do
    {:ok, %__MODULE__{client: client}}
  end

  def handle_cast(:close, s) do
    {:stop, :normal, s}
  end

  def handle_cast({:send_command, command}, s = %{log: log}) do
    {:noreply, %{s | log: [command | log]}}
  end

  def handle_cast(:get_chat, s = %{client: client, log: log}) do
    send(client, {:tcp, self(), @chat})
    {:noreply, %{s | log: [:get_chat | log]}}
  end

  def handle_cast({:get, opcode, arg}, s = %{log: log, client: client}) do
    send(client, {:tcp, self(), [219, 15, 73, 64]})
    {:noreply, %{s | log: [{:get, opcode, arg} | log]}}
  end

  def handle_cast(:clear_log, s) do
    {:noreply, %{s | log: []}}
  end

  def handle_call(:log, _, s = %{log: log}) do
    {:reply, Enum.reverse(log), s}
  end
end
