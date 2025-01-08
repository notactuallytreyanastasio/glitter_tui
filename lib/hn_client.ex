defmodule HnClient do
  @moduledoc """
  Fetches the top 10 Hacker News stories and their first comment (if any).
  """

  # We’ll use Req for HTTP requests
  def fetch_top_10 do
    # 1) Get a list of top story IDs
    top_ids =
      Req.get!("https://hacker-news.firebaseio.com/v0/topstories.json").body
      |> Enum.take(10)

    # 2) For each story ID, fetch the story data, then fetch its top comment
    Enum.map(top_ids, fn story_id ->
      story = Req.get!("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json").body

      # The "kids" field is a list of comment IDs. We'll grab the first one, if present.
      top_comment_text =
        case story["kids"] do
          [top_comment_id | _rest] ->
            # fetch the comment item
            comment = Req.get!("https://hacker-news.firebaseio.com/v0/item/#{top_comment_id}.json").body
            # Some comments might have HTML tags in the "text" field. 
            # We'll just return the raw text here, though you could sanitize it if needed.
            comment["text"] || "No text"
          
          _ ->
            # No comments or kids is nil/empty
            "No comments"
        end

      %{
        title: story["title"],
        top_comment: top_comment_text
      }
    end)
  end
end

