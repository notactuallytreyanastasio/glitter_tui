defmodule GlitterTui do
  @moduledoc """
  Simple demonstration of using ExNcurses to display bold text.
  """

  # We’ll just expose a `start/0` function
  def start do
    # Initialize curses
    :ok = ExNcurses.initscr()
    # Turn off line buffering, etc. if you like:
    ExNcurses.cbreak()
    ExNcurses.noecho()

    # We can also start color if we want
    ExNcurses.start_color()
    # Let's define a color pair (text color, background color).
    # This is optional if you just want white-on-black defaults.
    ExNcurses.init_pair(1, :white, :black)

    # Move the cursor to row=5, col=10 just as an example
    ExNcurses.move(5, 10)

    # Turn on bold attribute
    ExNcurses.attron(:bold)
    # Print the message
    ExNcurses.addstr("big ole musky glitter bunnies")
    # Turn bold off
    ExNcurses.attroff(:bold)

    # Refresh to show changes
    ExNcurses.refresh()

    # Wait for a keystroke so you can see the text
    ExNcurses.getch()

    # End ncurses mode, returning you to normal terminal
    ExNcurses.endwin()
  end
end

