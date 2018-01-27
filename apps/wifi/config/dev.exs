use Mix.Config

config :wifi, :settings_file, "/tmp/wifi.txt"

config :wifi, Network.WifiSetup, Network.FakeWifiSetup

config :wifi, :ntp_servers, []
