defmodule GlitterTui do
  @moduledoc """
  A tiny TUI that displays top 10 Hacker News headlines in bold.
  """

  def start do
    # 1) Initialize ncurses
    :ok = ExNcurses.initscr()
    ExNcurses.cbreak()
    ExNcurses.noecho()
    ExNcurses.start_color()

    # Define a color pair (foreground: white, background: black)
    ExNcurses.init_pair(1, :white, :black)

    # 2) Fetch headlines
    headlines = HnClient.fetch_top_10()

    # 3) Display them in bold, each separated by a blank line
    ExNcurses.attron(:bold)
    Enum.each(headlines, fn headline ->
      ExNcurses.addstr(headline)
      ExNcurses.addstr("\n\n")
    end)
    ExNcurses.attroff(:bold)

    # 4) Refresh the screen
    ExNcurses.refresh()

    # 5) Wait for a keypress so we can see them
    ExNcurses.getch()

    # 6) End the ncurses session
    ExNcurses.endwin()
  end
end

