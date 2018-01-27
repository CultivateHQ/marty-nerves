use Mix.Config

config :wifi, :ntp_servers, []

config :wifi, :settings_file, "/root/wifi.txt"

config :wifi, :node_name, Mix.Project.config()[:app]

config :wifi, :ntp_servers, [
  "0.pool.ntp.org",
  "1.pool.ntp.org",
  "2.pool.ntp.org",
  "3.pool.ntp.org"
]

import_config "config.secret.exs"
import_config "#{Mix.env()}.exs"
