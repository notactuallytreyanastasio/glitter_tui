defmodule GlitterTuiTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  test "start/0 prints something and exits on 'q'" do
    # We'll simulate pressing 'q' right away to quit.
    # The input: "q\n" means we send 'q' plus an Enter (newline).
    output =
      capture_io([input: "q\n"], fn ->
        GlitterTui.start()
      end)

    # Basic assertion: we expect to see "Goodbye!" in the output
    # since that's what we print upon quitting.
    assert output =~ "Goodbye!"

    # Optional: check for the instructions prompt
    assert output =~ "j=down"
    assert output =~ "k=up"
    assert output =~ "q=quit"
  end
end

