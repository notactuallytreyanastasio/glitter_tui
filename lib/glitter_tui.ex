defmodule GlitterTui do
  @moduledoc """
  Demonstrates a refactored approach:
  - `GlitterTui` fetches & formats data into lines
  - `Pager` submodule handles paging logic & user input
  """

  alias GlitterTui.Pager

  # ----------------------------------------------------------------------------
  # Public API: just call `GlitterTui.start()` to run the TUI.
  # ----------------------------------------------------------------------------
  def start do
    # 1) Fetch items from HN (assuming HnClient is elsewhere in your project)
    items = HnClient.fetch_top_10()

    # 2) Convert them to lines: each item -> [title_line, comment_line, ""]
    lines = convert_items_to_lines(items)

    # 3) Hand off to Pager
    Pager.start_pager(lines)
  end

  # ----------------------------------------------------------------------------
  # Private: transform items -> lines with minimal logic
  # ----------------------------------------------------------------------------
  defp convert_items_to_lines(items) do
    items
    |> Enum.flat_map(fn %{title: title, top_comment: comment} ->
      [
        format_title_line(title),
        strip_html(comment),
        ""
      ]
    end)
  end

  # We’ll do a simple “bright + underline” to replace the old :bold
  defp format_title_line(title) do
    # IO.ANSI.format returns an IO list, so let's iolist_to_binary it
    title_ansi = IO.ANSI.format([:bright, :underline, title, :reset])
    IO.iodata_to_binary(title_ansi)
  end

  # Very naive HTML stripper
  defp strip_html(html) do
    html
    |> String.replace(~r/<[^>]*>/, "")
    |> String.replace("\n", " ")
  end

  # ----------------------------------------------------------------------------
  # Submodule that handles all paging logic
  # ----------------------------------------------------------------------------
  defmodule Pager do
    @moduledoc """
    Handles "paging" lines of text in a TUI with j/k for next/prev page, q to quit.
    """

    def start_pager(lines) do
      # Figure out how many rows we have
      rows = detect_terminal_rows()
      # Let’s keep a few lines at the bottom for instructions
      page_size = max(rows - 4, 1)

      pager_loop(lines, 0, page_size)
    end

    # ----------------------------------------------------------------------------
    # Main loop: draws the page, handles user input
    # ----------------------------------------------------------------------------
    defp pager_loop(lines, offset, page_size) do
      clear_screen()

      lines
      |> Enum.slice(offset, page_size)
      |> Enum.each(&IO.puts/1)

      # Show controls
      IO.puts("\n[j=down, k=up, q=quit]\n")

      case IO.getn("") do
        "j" ->
          new_offset = min(offset + page_size, max(0, length(lines) - page_size))
          pager_loop(lines, new_offset, page_size)

        "k" ->
          new_offset = max(offset - page_size, 0)
          pager_loop(lines, new_offset, page_size)

        "q" ->
          # Clear screen on exit
          clear_screen()
          IO.puts("Goodbye!")
          :ok

        _ ->
          # Unrecognized key, do nothing, redraw
          pager_loop(lines, offset, page_size)
      end
    end

    # ----------------------------------------------------------------------------
    # Helpers
    # ----------------------------------------------------------------------------

    # Clears the screen and sets the cursor to top-left
    defp clear_screen do
      IO.write(IO.ANSI.clear() <> IO.ANSI.home())
    end

    # Use Erlang's :io.rows() for older Elixir versions that don’t have IO.rows()
    defp detect_terminal_rows do
      case :io.rows() do
        {:ok, rows} when is_integer(rows) and rows > 0 ->
          rows

        _ ->
          # fallback if we can't detect size
          24
      end
    end
  end
end
