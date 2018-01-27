defmodule Marty.Umbrella.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp deps do
    [
      {:dialyzex, "~> 1.0", only: :dev},
      {:credo, "~> 0.9.0-rc2", only: :dev}
    ]
  end
end
