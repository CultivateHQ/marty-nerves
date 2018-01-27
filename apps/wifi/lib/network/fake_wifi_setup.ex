defmodule Network.FakeWifiSetup do
  @moduledoc """
  Pretend to set up WiFi through `Nerves.Network`, but really DO NOTHING. Bwah, whah, wah.

  Zzzzzzz
  """

  use GenServer

  @name __MODULE__

  @behaviour Network.WifiSetup

  @spec setup_wifi(wifi_opts :: [key_mgmt: :"WPA-PSK" | none, ssid: String.t(), psk: String.t()]) ::
          :ok
  def setup_wifi(wifi_opts) do
    {:ok, _pid} = Registry.start_link(keys: :unique, name: Nerves.Udhcpc)
    GenServer.start_link(__MODULE__, wifi_opts, name: @name)
    :ok
  end

  def init(_) do
    {:ok, {}}
  end
end
