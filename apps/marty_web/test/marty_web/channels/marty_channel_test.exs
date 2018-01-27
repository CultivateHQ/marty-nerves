defmodule MartyWeb.MartyChannelTest do
  use MartyWeb.ChannelCase

  alias MartyWeb.MartyChannel
  alias NetTransport.FakeGenTcp
  alias Marty.Commands

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(MartyChannel, "marty")

    {:ok, socket: socket}
  end

  setup do
    assert fake_tcp = FakeGenTcp.connection_socket()
    FakeGenTcp.clear_log(fake_tcp)
    {:ok, fake_tcp: fake_tcp}
  end

  test "hello", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "hello", %{})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.hello(true)]
  end

  test "stop", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "stop", %{})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.stop(3)]
  end

  test "celebrate", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "celebrate", %{"speed" => "fast"})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.celebrate(1_000)]
  end

  test "walk", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "walk", %{direction: "forward", speed: "medium", steps: 3})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.walk(3, 0, 2_000, 50, 4)]
  end

  test "kick", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "kick", %{foot: "left", speed: "fast", twist: 10})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.kick(0, 10, 1_500)]
  end

  test "tap_foot", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "tap_foot", %{foot: "left"})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.tap_foot(0)]
  end

  test "circle dance", %{socket: socket, fake_tcp: fake_tcp} do
    ref = push(socket, "circle_dance", %{side: "left", speed: "fast"})
    assert_reply(ref, :ok)
    assert FakeGenTcp.log(fake_tcp) == [Commands.circle_dance(0, 1_500)]
  end
end
