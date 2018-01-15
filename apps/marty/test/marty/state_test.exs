defmodule Marty.StateTest do
  use ExUnit.Case
  alias Marty.State

  setup do
    State.subscribe()
    :ok
  end

  test "connecting" do
    State.connected()
    assert State.connected?
    assert_receive({:marty_state, %{connected?: true}})
  end

  test "disconnecting" do
    connect_and_flush_notifications()

    State.disconnected()
    refute State.connected?

    assert_receive({:marty_state, %{connected?: false}})
  end

  test "update battery" do
    connect_and_flush_notifications()
    State.update_battery(3.45)
    assert State.battery() == 3.45

    assert_receive({:marty_state, %{battery: 3.45}})
  end

  test "update accelerometer" do
    connect_and_flush_notifications()
    State.update_accelerometer(1.25, 0.0, -1.25)

    assert State.accelerometer() == %State.Accelerometer{x: 1.25, y: 0.0, z: -1.25}
    assert_receive({:marty_state, %{accelerometer: %{x: 1.25, y: 0.0, z: -1.25}}})
  end

  defp connect_and_flush_notifications do
    State.connected()
    assert_receive({:marty_state, %{connected?: true}})
  end
end
