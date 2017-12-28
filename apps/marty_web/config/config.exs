# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :marty_web,
  namespace: MartyWeb

# Configures the endpoint
config :marty_web, MartyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3IY0HMGW7Yp5oiS19uOXKWr+DlETBlABK5ZkZR4R7519X8CtlyyHelwLBzS6pVIu",
  render_errors: [view: MartyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MartyWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :marty_web, :generators,
  context_app: :marty

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
