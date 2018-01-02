defmodule Mix.Tasks.BrunchBuild do
  @moduledoc """
  Runs brunch build (in production) mode. Added to the Phoenix project Mix file, so that assets
  are prepared as part of a production build:

  Added to the project keyword list:
  ```
  aliases: aliases(Mix.env),
  ```

  plus

  ```
  def aliases(:prod) do
  [
    "compile": ["compile", "brunch_build", "phx.digest"]
  ]
  end
  def aliases(_), do: []

  ```
  """

  use Mix.Task

  require Logger
  @shortdoc "Runs the brunch build in production mode"

  def run(_args) do
    Mix.Shell.cmd("cd assets && brunch build --production", [], fn x -> Logger.info inspect({:brunch_build, x}) end)
  end
end
