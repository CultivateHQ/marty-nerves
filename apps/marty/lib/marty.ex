defmodule Marty do
  @moduledoc """
  Sends actual commands to Marty.

  See `Marty.CommandDefinitions`
  """

  use Marty.CommandDefinitions, :call_commands
end
