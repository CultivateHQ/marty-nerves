defmodule Fw.MixProject do
  use Mix.Project

  @target (case Mix.env() do
             :prod -> "rpi0"
             _ -> "host"
           end)

  System.put_env("MIX_TARGET", @target)

  Mix.shell().info([
    :green,
    """
    Mix environment
    MIX_TARGET:   #{@target}
    MIX_ENV:      #{Mix.env()}
    """,
    :reset
  ])

  def project do
    [
      app: :fw,
      version: "0.1.0",
      elixir: "~> 1.4",
      target: @target,
      archives: [nerves_bootstrap: "~> 0.8"],
      deps_path: "../../deps/#{@target}",
      build_path: "../../_build/#{@target}",
      config_path: "../../config/config.exs",
      lockfile: "../../mix.lock.#{@target}",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: [loadconfig: [&bootstrap/1]],
      deps: deps()
    ]
  end

  def bootstrap(args) do
    Application.start(:nerves_bootstrap)
    Mix.Task.run("loadconfig", args)
  end

  def application, do: application(@target)

  def application("host") do
    [extra_applications: [:logger]]
  end

  def application(_target) do
    [mod: {Fw.Application, []}, extra_applications: [:logger]]
  end

  defp deps do
    [
      {:nerves, "~> 0.9", runtime: false},
      {:camera, in_umbrella: true},
      {:image_server, in_umbrella: true},
      {:marty, in_umbrella: true},
      {:wifi, in_umbrella: true},
      {:marty_web, in_umbrella: true}
    ] ++ deps(@target)
  end

  defp deps("host"), do: []

  defp deps(target) do
    [
      {:shoehorn, "~> 0.2"},
      {:nerves_runtime, "~> 0.4"},
      {:nerves_init_gadget, ">= 0.0.0"}
    ] ++ system(target)
  end

  defp system("rpi0"), do: [{:nerves_system_rpi0, ">= 0.0.0", runtime: false}]
  # defp system("rpi"), do: [{:nerves_system_rpi, ">= 0.0.0", runtime: false}]
  # defp system("rpi2"), do: [{:nerves_system_rpi2, ">= 0.0.0", runtime: false}]
  # defp system("rpi3"), do: [{:nerves_system_rpi3, ">= 0.0.0", runtime: false}]
  # defp system("bbb"), do: [{:nerves_system_bbb, ">= 0.0.0", runtime: false}]
  # defp system("ev3"), do: [{:nerves_system_ev3, ">= 0.0.0", runtime: false}]
  # defp system("qemu_arm"), do: [{:nerves_system_qemu_arm, ">= 0.0.0", runtime: false}]
  # defp system("x86_64"), do: [{:nerves_system_x86_64, ">= 0.0.0", runtime: false}]
  # defp system(target), do: Mix.raise("Unknown MIX_TARGET: #{target}")
end
