defmodule Camera.Cam do
  @moduledoc """
  Either the PiCam or a fake one
  """

  @callback next_frame() :: [byte]
  @callback start_link() :: {:ok, pid} | :ignore | {:error, any()}

  def impl do
    Application.get_env(:camera, __MODULE__)
  end
end
