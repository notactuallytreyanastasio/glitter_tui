defmodule GlitterTui do
  @moduledoc """
  A tiny TUI that displays top 10 Hacker News headlines
  in bold and underlined text, separated by blank lines.
  """

  def start do
    :ok = ExNcurses.initscr()
    ExNcurses.cbreak()
    ExNcurses.noecho()
    ExNcurses.start_color()
    ExNcurses.scrollok(ExNcurses.stdscr(), true)
    ExNcurses.idlok(ExNcurses.stdscr(), true)

    # Let's say your HnClient now returns [%{title: ..., top_comment: ...}, ...]
    items = HnClient.fetch_top_10()

    for %{title: title, top_comment: comment} <- items do
      # Title in bold+underline
      ExNcurses.attron(:bold)
      ExNcurses.attron(:underline)
      ExNcurses.addstr(title)
      ExNcurses.attroff(:underline)
      ExNcurses.attroff(:bold)

      ExNcurses.addstr("\n")
      ExNcurses.addstr(comment)
      ExNcurses.addstr("\n\n")
    end

    ExNcurses.refresh()
    # Wait for a keypress
    ExNcurses.getch()
    ExNcurses.endwin()
  end
end

