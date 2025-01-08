defmodule GlitterTui do
  def start do
    # 1) Fetch items
    items = HnClient.fetch_top_10()

    # 2) Flatten them into lines
    lines =
      items
      |> Enum.flat_map(fn %{title: title, top_comment: comment} ->
        [
          # Use :bright if your Elixir says :bold is invalid
          # We'll convert the iolist to a string via IO.iodata_to_binary/1
          IO.iodata_to_binary(IO.ANSI.format([:bright, :underline, title, :reset])),
          strip_html(comment),
          ""
        ]
      end)

    # 3) Try to detect the terminal height (rows)
    rows = rows_fallback()

    # Subtract some lines for the prompt or spacing
    page_size = max(rows - 4, 1)

    pager_loop(lines, 0, page_size)
  end

  defp pager_loop(lines, offset, page_size) do
    IO.write(IO.ANSI.clear() <> IO.ANSI.home())

    lines
    |> Enum.slice(offset, page_size)
    |> Enum.each(&IO.puts/1)

    IO.puts("\n[j = down | k = up | q = quit]\n")

    case IO.getn("") do
      "j" ->
        new_offset = min(offset + page_size, max(0, length(lines) - page_size))
        pager_loop(lines, new_offset, page_size)

      "k" ->
        new_offset = max(offset - page_size, 0)
        pager_loop(lines, new_offset, page_size)

      "q" ->
        IO.write(IO.ANSI.clear() <> IO.ANSI.home())
        IO.puts("Goodbye!")
        :ok

      _ ->
        pager_loop(lines, offset, page_size)
    end
  end

  defp strip_html(comment) do
    comment
    |> String.replace(~r/<[^>]*>/, "")
    |> String.replace("\n", " ")
  end

  # The fallback function using :io.rows()
  defp rows_fallback do
    case :io.rows() do
      {:ok, rows} when is_integer(rows) and rows > 0 ->
        rows

      _ ->
        24
    end
  end
end

