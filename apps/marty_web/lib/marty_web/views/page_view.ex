defmodule MartyWeb.PageView do
  use MartyWeb, :view

  def control_row_definitions do
    [
      [{"forward-left", "nwarr"}, {"forward", "uarr"}, {"forward-right", "nearr"}],
      [{"side-left", "larr"}, {"stop", "otimes"}, {"side-right", "rarr"}],
      [{"back-left", "swarr"}, {"back", "darr"}, {"back-right", "searr"}]
    ]
  end

  def steps_select do
    for steps <- [1, 2, 3, 5, 8, 13, 21, 44, 65, 109] do
      description = if steps == 1 do
        "1 step"
      else
        "#{steps} steps"
      end

      selected = if steps == 3 do
        "selected"
      else
        ""
      end

      {steps, description, selected}
    end
  end
end
