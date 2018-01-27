defmodule Wifi.SettingsTest do
  use ExUnit.Case

  alias Wifi.Settings

  setup do
    filename = "#{System.tmp_dir!()}/#{inspect(self())}.txt"
    Application.put_env(:wifi, :settings, key_mgmt: :"WPA-PSK", psk: "secret", ssid: "myssid")

    on_exit(fn ->
      File.rm(filename)
    end)

    {:ok, filename: filename}
  end

  test "defaults to application settings", %{filename: filename} do
    assert [key_mgmt: :"WPA-PSK", psk: "secret", ssid: "myssid"] ==
             Settings.read_settings(filename)
  end

  test "overrides ssid and secret", %{filename: filename} do
    Settings.set(filename, {"bobby", "clitheroe"})

    assert Keyword.equal?(
             [key_mgmt: :"WPA-PSK", psk: "clitheroe", ssid: "bobby"],
             Settings.read_settings(filename)
           )
  end

  @tag capture_log: true
  test "uses defaults if file has weird things in it", %{filename: filename} do
    File.write(filename, :erlang.term_to_binary([1, 2, 3]))

    assert [key_mgmt: :"WPA-PSK", psk: "secret", ssid: "myssid"] ==
             Settings.read_settings(filename)
  end

  @tag capture_log: true
  test "uses defaults if file is corrupt", %{filename: filename} do
    File.write(filename, "Liam Fox")

    assert [key_mgmt: :"WPA-PSK", psk: "secret", ssid: "myssid"] ==
             Settings.read_settings(filename)
  end
end
