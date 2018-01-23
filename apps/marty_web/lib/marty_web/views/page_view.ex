defmodule MartyWeb.PageView do
  use MartyWeb, :view

  def control_row_definitions do
    [
      [{"forward-left", "nwarr"}, {"forward", "uarr"}, {"forward-right", "nearr"}],
      [{"side-left", "larr"}, {"stop", "otimes"}, {"side-right", "rarr"}],
      [{"back-left", "swarr"}, {"back", "darr"}, {"back-right", "searr"}],
    ]
  end
end
