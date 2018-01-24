defmodule Marty.DiscoverTest do
  use ExUnit.Case
  alias Marty.{Discover, State}
  alias NetTransport.{FakeGenUdp}

  setup do
    State.disconnected()
    Discover.subscribe()

    %{socket: sock} = :sys.get_state(Discover)

    FakeGenUdp.clear_log(sock)

    {:ok, socket: sock}
  end

  test "receiving an IP", %{socket: sock} do
    FakeGenUdp.recv_this_next(sock, {{10, 0, 0, 10}, 4000, "Marty"})
    poll_discover()

    assert FakeGenUdp.log(sock) == [{{224, 0, 0, 1}, 4000, "AA"}]
    assert_receive {:marty_discover, {{10, 0, 0, 10}, "Marty"}}
  end

  test "no marty polling if connected", %{socket: sock} do
    State.connected()
    poll_discover()
    assert FakeGenUdp.log(sock) == []
  end

  test "no ip received", %{socket: sock} do
    poll_discover()

    assert FakeGenUdp.log(sock) == [{{224, 0, 0, 1}, 4000, "AA"}]
    refute_receive {:marty_discover, _}
  end

  defp poll_discover do
    send(Discover, :poll)
    :sys.get_state(Discover)
  end
end
