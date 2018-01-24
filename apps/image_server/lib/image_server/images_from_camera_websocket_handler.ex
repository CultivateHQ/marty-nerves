defmodule ImageServer.ImagesFromCameraWebsocketHandler do
  @moduledoc """
  Receives images one frame at a time from the browser and broadcasts.
  """

  @behaviour :cowboy_websocket_handler
  require Logger

  def init({_tcp, _http}, _req, _opts) do
    {:upgrade, :protocol, :cowboy_websocket}
  end

  def websocket_init(_transport, req, _opts) do
    send(self(), :next_frame)
    {:ok, req, %{}}
  end

  def websocket_terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_handle(data, req, state) do
    Logger.warn fn -> "Unexpected websocket_handle: #{inspect({data, req, state})}" end
    {:ok, req, state}
  end

  def websocket_info(:next_frame, req, state) do
    image = Camera.next_frame
    Process.send_after(self(), :next_frame, 50)
    {:reply, {:binary, image}, req, state}
  end

  def websocket_info(info, req, state) do
    Logger.warn fn -> "Unexpected websocket_info: #{inspect({info, req, state})}" end
    {:ok, req, state}
  end
end
