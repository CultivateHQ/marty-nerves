defmodule Wifi.Ntp do
  @moduledoc """
  This polls every second until the time is set, then every 30 minutes afterwards. `ntpd` is attempted to be used at each poll
  to set the time, using the configured timeserver.

  `ntpd` it now no longer returns if it cannot resolve the timeserver. This can be a problem is the network isn't up yet. So
  before attempting to call `ntpd` we try and resolve the first server using `:inet.gethostbyname/1` and only call `ntpd` if the
  resolution works.
  """

  @name __MODULE__

  @poll_after_time_set :timer.minutes(30)
  @poll_after_not_set :timer.seconds(1)

  @ntpd "ntpd"

  require Logger

  defstruct ntp_args: nil, first_server: nil, time_set: true

  @spec start_link(list(String.t())) :: {:ok, pid}
  def start_link(ntp_servers) do
    GenServer.start_link(__MODULE__, ntp_servers, name: @name)
  end

  # do nothing
  def init([]), do: {:ok, {}}

  def init(ntp_servers = [first_server | _]) do
    send(self(), :poll)

    {:ok,
     %__MODULE__{
       first_server: String.to_charlist(first_server),
       ntp_args: ["-n", "-q", "-p" | ntp_servers]
     }}
  end

  def handle_info(:poll, s = %{first_server: first_server, ntp_args: ntp_args}) do
    repoll =
      case :inet.gethostbyname(first_server) do
        {:ok, _} ->
          set_time(ntp_args)

        _ ->
          # Logger.debug("Not ready to set time, yet")
          @poll_after_not_set
      end

    Process.send_after(self(), :poll, repoll)
    {:noreply, s}
  end

  defp set_time(ntp_args) do
    Logger.info("About to set time")
    System.cmd(@ntpd, ntp_args)

    if DateTime.utc_now().year > 2016 do
      @poll_after_time_set
    else
      @poll_after_not_set
    end
  end
end
