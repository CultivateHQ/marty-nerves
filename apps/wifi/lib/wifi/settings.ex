defmodule Wifi.Settings do
  @moduledoc """
  Used to change WiFi settings without changing firmware. By default returns the settings provided
  in the application configuration `:wifi, :settings` but allows the `ssid` and `secret` to be overriden.

  The settings are written to a file, allowing changes to persist between boots.
  """
  require Logger

  @doc """
  Read the WiFi settings, overrideing `:ssid` and `:secret` from the file, which may have been previously written with `set`.

  If the file doesn not exist, or is invalid, then `Application.fetch_env!(:wifi, :settings)` is returned. If the file does exist, then the
  same configuration is returned but with `ssid` and `secret` overrideen with those from the file.

  Sho
  """
  @spec read_settings(String.t()) :: list
  def read_settings(file) do
    with {:ok, binary} <- File.read(file),
         {ssid, secret} <- decode_file_contents(binary) do
      Keyword.merge(default_settings(), ssid: ssid, psk: secret)
    else
      {:error, :enoent} ->
        # Not been set - it's fine
        default_settings()

      other ->
        Logger.error("Unexpected problem reading WiFi settings file: #{inspect(other)}")
        default_settings()
    end
  end

  @doc """
  Write the `ssid` and `secret` tuple to the file, which will subsequently override those options
  if the file is passed to `read_settings/1`o
  """
  @spec set(String.t(), {String.t(), String.t()}) :: :ok | {:error, atom}
  def set(file, settings = {_ssid, _secret}) do
    File.write(file, :erlang.term_to_binary(settings))
  end

  defp default_settings do
    Application.fetch_env!(:wifi, :settings)
  end

  defp decode_file_contents(binary) do
    try do
      :erlang.binary_to_term(binary)
    rescue
      ArgumentError ->
        "Corrupt file"
    end
  end
end
