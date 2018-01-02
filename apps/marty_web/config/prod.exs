use Mix.Config

config :marty_web, MartyWeb.Endpoint,
  # url: [host: "example.com", port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  check_origin: false,
  http: [port: 80]

# import_config "prod.secret.exs"
