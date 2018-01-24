defmodule Camera.RealCam do
  @moduledoc """
  Essentially sits in front of PiCam
  """

  @behaviour Camera.Cam

  defdelegate start_link, to: Picam.Camera
  defdelegate next_frame, to: Picam
end
