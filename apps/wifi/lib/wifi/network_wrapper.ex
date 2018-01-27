defmodule Wifi.NetworkWrapper do
  @moduledoc """
  Responsible for setting up WiFi with `Nerves.Network`.

  Uses `WiFi.Settings` to access the WiFi config in such a way that the SSID and secret can be overwritten
  without having to replace the firmware image.

  By setting up the WiFi in a process we can take the connection down and create a new one when the SSSID
  and secret are changed with `Wifi.set/2`.

  """

  use GenServer
  require Logger

  alias Wifi.Settings
  alias Network.WifiSetup

  @name __MODULE__

  @doc """
  The settings file is the one used to store any changed SSID and secret settings.
  """
  @spec start_link(String.t()) :: {:ok, pid}
  def start_link(settings_file) do
    GenServer.start_link(__MODULE__, settings_file, name: @name)
  end

  def init(settings_file) do
    wifi_opts = Settings.read_settings(settings_file)

    :ok = WifiSetup.impl().setup_wifi(wifi_opts)
    {:ok, {}}
  end
end
