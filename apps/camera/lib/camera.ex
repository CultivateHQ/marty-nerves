defmodule Camera do
  @moduledoc """
  Sits in front of PiCam.
  """

  alias Camera.Cam

  def next_frame(), do: Cam.impl().next_frame()
end
