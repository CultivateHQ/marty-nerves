defmodule MartyWeb.MartyChannel do
  @moduledoc """
  Control channel.
  """

  use MartyWeb, :channel

  alias MartyWeb.{WalkCommand, KickCommand}

  @marty Application.get_env(:marty_channel, :marty, Marty)

  def join("marty", _payload, socket) do
    Marty.State.subscribe()
    {:ok, socket}
  end

  def handle_in("hello", _, socket) do
    @marty.hello(true)
    {:reply, :ok, socket}
  end

  def handle_in("stop", _, socket) do
    @marty.stop(3)
    {:reply, :ok, socket}
  end

  def handle_in("celebrate", %{"duration" => duration}, socket) do
    celebration_time =
      case duration do
        "quick" -> 1_000
        "slow" -> 15_000
        _ -> 5_000
      end

    @marty.celebrate(celebration_time)
    {:reply, :ok, socket}
  end

  def handle_in("walk", %{"direction" => direction, "speed" => speed, "steps" => steps}, socket) do
    {f, a} = WalkCommand.to_walk_command(direction, speed, steps)
    apply(@marty, f, a)
    {:reply, :ok, socket}
  end

  def handle_in("kick", %{"foot" => foot, "speed" => speed, "twist" => twist}, socket) do
    {f, a} = KickCommand.to_kick(foot, twist, speed)
    apply(@marty, f, a)
    {:reply, :ok, socket}
  end

  def handle_info({:marty_state, marty_state}, socket) do
    push(socket, "marty_state", marty_state)
    {:noreply, socket}
  end

  def handle_info({:marty_chat, msg}, socket) do
    push(socket, "marty_chat", %{msg: msg})
    {:noreply, socket}
  end
end
