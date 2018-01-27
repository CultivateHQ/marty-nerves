defmodule Network.WifiSetup do
  @moduledoc """
  Contract around Nerves Network for WiFi
  """

  @doc """
  Set up WiFi on "wlan0" with the optiosn provided. Or at least pretend to do so.
  """
  @callback setup_wifi(
              wifi_opts :: [key_mgmt: :"WPA-PSK" | none, ssid: String.t(), psk: String.t()]
            ) :: {:ok, pid}

  @doc """
  Actual implementation module to use in this environment
  """
  def impl do
    Application.get_env(:wifi, __MODULE__)
  end
end
