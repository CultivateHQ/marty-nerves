defmodule Marty.QueriesTest do
  use ExUnit.Case

  alias Marty.Queries

  test "battery" do
    assert <<0x01, 0x01, 0x00>> == Queries.battery()
  end

  test "accelerometer" do
    assert <<0x01, 0x02, 0x00>> == Queries.accelerometer(:x)
    assert <<0x01, 0x02, 0x01>> == Queries.accelerometer(:y)
    assert <<0x01, 0x02, 0x02>> == Queries.accelerometer(:z)
  end

  test "decode result" do
    assert 0.0 == Queries.decode_result([0, 0, 0, 0])

    assert_in_delta Queries.decode_result([154, 233, 118, 68]),  987.65, 0.001
  end
end
