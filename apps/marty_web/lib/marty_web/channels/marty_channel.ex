defmodule MartyWeb.MartyChannel do
  @moduledoc """
  Control channel.
  """

  use MartyWeb, :channel

  alias MartyWeb.{WalkCommand, KickCommand, FunCommands}

  def join("marty", _payload, socket) do
    Marty.State.subscribe()
    {:ok, socket}
  end

  def handle_in("hello", _, socket) do
    Marty.hello(true)
    {:reply, :ok, socket}
  end

  def handle_in("stop", _, socket) do
    Marty.stop(3)
    {:reply, :ok, socket}
  end

  def handle_in("celebrate", %{"speed" => speed}, socket) do
    speed
    |> FunCommands.to_celebrate()
    |> do_marty_command(socket)

    {:reply, :ok, socket}
  end

  def handle_in("walk", %{"direction" => direction, "speed" => speed, "steps" => steps}, socket) do
    direction
    |> WalkCommand.to_walk_command(speed, steps)
    |> do_marty_command(socket)
  end

  def handle_in("kick", %{"foot" => foot, "speed" => speed, "twist" => twist}, socket) do
    foot
    |> KickCommand.to_kick(twist, speed)
    |> do_marty_command(socket)
  end

  def handle_in("tap_foot", %{"foot" => foot}, socket) do
    foot
    |> FunCommands.to_tap_foot()
    |> do_marty_command(socket)
  end

  def handle_in("circle_dance", %{"side" => side, "speed" => speed}, socket) do
    side
    |> FunCommands.to_circle_dance(speed)
    |> do_marty_command(socket)
  end

  def handle_info({:marty_state, marty_state}, socket) do
    push(socket, "marty_state", marty_state)
    {:noreply, socket}
  end

  def handle_info({:marty_chat, msg}, socket) do
    push(socket, "marty_chat", %{msg: msg})
    {:noreply, socket}
  end

  defp do_marty_command({f, a}, socket) do
    apply(Marty, f, a)
    {:reply, :ok, socket}
  end
end
