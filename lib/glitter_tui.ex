defmodule GlitterTui do
  @moduledoc """
  Minimal TUI in pure Elixir using ANSI codes and auto-detected terminal height.
  
  Controls:
    j = down one page
    k = up one page
    q = quit
  """

  def start do
    # 1) Fetch HN items (assuming you return a list of maps: [%{title: "...", top_comment: "..."}, ...])
    items = HnClient.fetch_top_10()

    # 2) Convert items to lines (2 lines per item + a blank line)
    lines =
      items
      |> Enum.flat_map(fn %{title: title, top_comment: comment} ->
        [
          # Use :bright instead of :bold in Elixir 1.18+
          IO.ANSI.format([:bright, :underline, title, :reset]) |> IO.iodata_to_binary(),
          strip_html(comment),
          ""
        ]
      end)

    # 3) Detect terminal rows. If 0, fallback to 10
    rows = case :io.rows() do
      {:ok, 0} -> 10
      {:ok, r} -> r
    end

    # Let’s say we want to reserve ~4 lines for prompt/instructions
    page_size = max(rows - 4, 1)

    pager_loop(lines, 0, page_size)
  end

  # A simple function to strip out HTML tags & newlines from the comment
  defp strip_html(comment) do
    comment
    |> String.replace(~r/<[^>]*>/, "")
    |> String.replace("\n", " ")
  end

  # The pager loop
  defp pager_loop(lines, offset, page_size) do
    # Clear screen and reset cursor
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())

    # Print the chunk of lines for the current "page"
    lines
    |> Enum.slice(offset, page_size)
    |> Enum.each(&IO.puts/1)

    # Show basic controls
    IO.puts("\n[j = down  |  k = up  |  q = quit]")

    case IO.getn("") do
      "j" ->
        new_offset = min(offset + page_size, max(0, length(lines) - page_size))
        pager_loop(lines, new_offset, page_size)

      "k" ->
        new_offset = max(offset - page_size, 0)
        pager_loop(lines, new_offset, page_size)

      "q" ->
        # Clear screen on exit
        IO.write(IO.ANSI.clear() <> IO.ANSI.home())
        IO.puts("Goodbye!")
        :ok

      _ ->
        # Unrecognized key, just redraw the same page
        pager_loop(lines, offset, page_size)
    end
  end
end

