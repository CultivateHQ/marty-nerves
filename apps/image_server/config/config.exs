use Mix.Config

config :image_server, :cowboy_options, [port: 4500]

import_config "#{Mix.env}.exs"
