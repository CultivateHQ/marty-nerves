defmodule Marty.Commands do
  @moduledoc """
  Creates binary commands to send to Marty, as defined in http://docs.robotical.io/hardware/esp-socket-api/

  See `Marty.CommandDefinitions`
  """

  use Marty.CommandDefinitions, :define_commands
end
