defmodule Marty.QueriesTest do
  use ExUnit.Case

  alias Marty.Queries

  test "battery" do
    assert <<0x01, 0x01, 0x00>> == Queries.battery()
  end

  test "get_chatter" do
    assert <<0x01, 0x05, 0x00>> == Queries.get_chatter()
  end

  test "accelerometer" do
    assert <<0x01, 0x02, 0x00>> == Queries.accelerometer(:x)
    assert <<0x01, 0x02, 0x01>> == Queries.accelerometer(:y)
    assert <<0x01, 0x02, 0x02>> == Queries.accelerometer(:z)
  end

  test "decode result" do
    assert 0.0 == Queries.decode_result([0, 0, 0, 0])

    assert_in_delta Queries.decode_result([154, 233, 118, 68]), 987.65, 0.001
  end

  test "read_chatter" do
    assert :not_chatter == Queries.read_chatter([34, 35, 36, 37])

    assert {:ok, "hello"} == Queries.read_chatter([34, 35, 36, 37] ++ 'hello' ++ [0])

    assert :not_chatter == Queries.read_chatter([34, 35, 36, 37] ++ 'hello' ++ [1])
    assert :not_chatter == Queries.read_chatter([34, 35, 36, 37] ++ 'hell' ++ [1, 0])
  end

  test "read_gpio_pin" do
    assert <<1, 4, 0>> == Queries.read_gpio_pin(0)
    assert <<1, 4, 3>> == Queries.read_gpio_pin(3)
  end

  test "interpret gpio pin on/off values" do
    assert Queries.interpret_gpio_pin_on_off(0.0) == false
    assert Queries.interpret_gpio_pin_on_off(0.1) == false
    assert Queries.interpret_gpio_pin_on_off(0.9) == true
    assert Queries.interpret_gpio_pin_on_off(1.0) == true
  end
end
