defmodule MartyWeb.MartyChannelTest do
  use MartyWeb.ChannelCase

  alias MartyWeb.MartyChannel

  setup do
    {:ok, _, socket} =
      socket("user_id", %{some: :assign})
      |> subscribe_and_join(MartyChannel, "marty")

    {:ok, socket: socket}
  end
end
