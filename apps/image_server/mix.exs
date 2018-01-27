defmodule ImageServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :image_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {ImageServer.Application, []}
    ]
  end

  defp deps do
    [
      {:plug, ">= 0.0.0"},
      {:cowboy, "~> 1.0"},
      {:camera, in_umbrella: true}
    ]
  end
end
