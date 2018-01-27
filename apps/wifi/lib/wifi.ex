defmodule Wifi do
  @moduledoc """
  Enables overriding of firmware WiFi options. Note that I can't be bothered supporting
  networks without security.
  """

  alias Wifi.{Settings, NetworkWrapperSupervisor, NetworkWrapper}

  @type ssid :: String.t()
  @type secret :: String.t()

  @doc """
  Override existing `ssid` and `secret`. The current WiFi is terminated and will be replaced with the new settings.

  The settings are persisted between boots.
  """
  @spec set(ssid, secret) :: :ok
  def set(ssid, secret) do
    Settings.set(settings_file(), {ssid, secret})
    Supervisor.terminate_child(NetworkWrapperSupervisor, NetworkWrapper)
    {:ok, _pid} = Supervisor.restart_child(NetworkWrapperSupervisor, NetworkWrapper)
    :ok
  end

  def settings do
    Settings.read_settings(settings_file())
  end

  @doc """
  The path to the settings file
  """
  @spec settings_file() :: String.t()
  def settings_file() do
    Application.fetch_env!(:wifi, :settings_file)
  end
end
