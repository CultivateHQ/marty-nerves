defmodule Network.RealWifiSetup do
  @moduledoc """
  Actually set up WiFi through `Nerves.Network`
  """

  @behaviour Network.WifiSetup

  @spec setup_wifi(wif_opts :: [key_mgmt: :"WPA-PSK" | none, ssid: String.t(), psk: String.t()]) ::
          :ok
  def setup_wifi(wifi_opts) do
    Nerves.Network.setup("wlan0", wifi_opts)
  end
end
