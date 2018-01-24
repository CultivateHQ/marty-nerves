defmodule Marty.Events do
  def subscribe(topic) do
    Registry.register(Marty.Event.Registry, topic, [])
  end

  def broadcast(topic, event) do
    Registry.dispatch(Marty.Event.Registry, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, event)
    end)
  end
end
