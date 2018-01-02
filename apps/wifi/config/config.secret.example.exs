use Mix.Config

config :wifi, :settings, key_mgmt: :"WPA-PSK", psk: "secret", ssid: "my_accesspoint_name"
