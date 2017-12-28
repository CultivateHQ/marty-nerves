defmodule Marty.CommandsTest do
  use ExUnit.Case

  alias Marty.Commands

  describe "some commands" do
    test "enable safeties" do
      assert <<0x02, 0x01, 0x00, 0x1e>> == Commands.enable_safeties()
    end

    test "hello" do
      assert <<0x02, 0x02, 0x00, 0x00, 0x01>> == Commands.hello(true)
      assert <<0x02, 0x01, 0x00, 0x00>> == Commands.hello(false)
    end

    test "celebrate" do
      assert <<0x02, 0x03, 0x00, 0x08, 0xff, 0x00>> == Commands.celebrate(255)
    end
  end

end
