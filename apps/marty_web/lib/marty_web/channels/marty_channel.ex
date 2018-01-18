defmodule MartyWeb.MartyChannel do
  use MartyWeb, :channel

  def join("marty", _payload, socket) do
    Marty.State.subscribe()
    {:ok, socket}
  end


  def handle_in("hello", _, socket) do
    Marty.hello(false)
    {:reply, :ok, socket}
  end

  def handle_in("celebrate", %{"duration" => duration}, socket) do
    celebration_time = case duration do
                        "quick" -> 1_000
                        "slow" -> 15_000
                        _ -> 5_000
                      end
    Marty.celebrate(celebration_time)
    {:reply, :ok, socket}
  end

  def handle_in("walk", %{"direction" => direction}, socket) do
    turn = case direction do
             "left" -> 100
             "right" -> -100
             _ -> 0
           end
    step_length = case direction do
                    "back" -> -100
                    _ -> 100
                  end
    IO.inspect {direction, turn, step_length}
    Marty.walk(3, turn, 5_000, step_length, 4)
    {:reply, :ok, socket}
  end

  def handle_info({:marty_state, marty_state}, socket) do
    push socket, "marty_state", marty_state
    {:noreply, socket}
  end
end
