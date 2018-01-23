defmodule Marty.StateTest do
  use ExUnit.Case
  alias Marty.State

  setup do
    State.subscribe()
    :ok
  end

  test "connecting" do
    State.connected()
    assert State.connected?()
    assert_receive({:marty_state, %{connected?: true}})
  end

  test "disconnecting" do
    connect_and_flush_notifications()

    State.disconnected()
    refute State.connected?()

    assert_receive({:marty_state, %{connected?: false}})
  end

  test "update battery" do
    connect_and_flush_notifications()
    State.update_battery(3.45)
    assert State.battery() == 3.45

    assert_receive({:marty_state, %{battery: 3.45}})
  end

  test "chat message received" do
    State.chat_message_received("hello")
    :sys.get_state(State)
    assert_receive({:marty_chat, "hello"})
  end

  defp connect_and_flush_notifications do
    State.connected()
    assert_receive({:marty_state, %{connected?: true}})
  end
end
