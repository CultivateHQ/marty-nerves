defmodule MartyWeb.PageView do
  use MartyWeb, :view

  def motion_definitions do
    [
      {"forward", "Walk forward"},
      {"back", "Walk back"},
      {"side-left", "Walk left"},
      {"side-right", "Walk right"},
      {"forward-left", "Walk forward-left"},
      {"forward-right", "Walk forward-right"},
      {"back-left", "Walk back-left"},
      {"back-right", "Walk back-right"},
      {"tap-left", "Tap left"},
      {"tap-right", "Tap right"},
      {"kick-left", "Kick left"},
      {"kick-right", "Kick right"},
      {"circle-left", "Circle left"},
      {"circle-right", "Circle right"},
      {"celebrate", "Celebrate!"}
    ]
  end

  def steps_select do
    for steps <- [1, 2, 3, 5, 8, 13, 21, 44, 65, 109] do

      selected = if steps == 3 do
        "selected"
      else
        ""
      end

      {steps, selected}
    end
  end
end
