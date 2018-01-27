use Mix.Config

config :marty_web, namespace: MartyWeb

config :marty_web, MartyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3IY0HMGW7Yp5oiS19uOXKWr+DlETBlABK5ZkZR4R7519X8CtlyyHelwLBzS6pVIu",
  render_errors: [view: MartyWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: MartyWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :marty_web, :generators, context_app: :marty

import_config "#{Mix.env()}.exs"
