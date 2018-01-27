defmodule Marty.Events do
  @moduledoc """
  Subscribe and receive Marty related events.
  """

  def subscribe(topic) do
    Registry.register(Marty.Event.Registry, topic, [])
  end

  def broadcast(topic, event) do
    Registry.dispatch(Marty.Event.Registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, event)
    end)
  end
end
