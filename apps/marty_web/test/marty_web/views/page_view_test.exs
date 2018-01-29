defmodule MartyWeb.PageViewTest do
  use MartyWeb.ConnCase, async: true

  import MartyWeb.PageView

  test "steps_select" do
    assert [{1, "1 step", ""},
            {2, "2 steps", ""},
            {3, "3 steps", "selected"} | _] = steps_select()
  end
end
