# A Senior Developer's First Earnest And Super Lazy As Hell Attempt At Making An App With AI
## Purpose
This is met to be a couple things.

1. A guide for someone totally fresh on LLMs to get started doing something real with one
2. Be a look at how these things work and reason and might tie into a senior developer's workflow
3. Be some commentary on all of this stuff and how it works, and share my thoughts and curiosities

I do this by building a TUI for the top 10 Hacker News stories, getting through 3 iterations, then adding some larger features.

### This is all from reviewing a Chat GPT o1 model chat you can [see here](https://chatgpt.com/share/677dd787-c3c8-8006-a232-e5797090bb6f).

The document from here on out is an exploration that kind of covers what interests me as I do this.

### Is this special?
No, I don't claim this to be an expert's guide.
I don't view it as a big swing into the space someone should follow exactly.
What I wanted to compile was a combination of allowing any developer whose curious a look at what this looked like for someone else getting from 0 to not just a working app, but 3 versions of one iterated upon one another.

Overall, it's just an exploration document, but I thought it might be one that would help other developers navigate our new world of LLMs on a few levels.

#### Some people will see this and go 'duh'

## TL;DR
Constraints:
1. No code editing or writing, just running terminal commands and copy/paste
2. 2 hours
3. Be as brief as possible, dont lay it out super easily for the machine

Within these constraints, I used GPT o1 and to build 3 iterations of a TUI that displays the top 10 HN stories, and also a web UI with a pubsub layer showing those stories updated live.

## Actually Interesting Part

### A Guide to diving into AI assistance as an outsider
#### Starting Prompt
I began with a very simple prompt:

> how would I make a terminal UI (TUI) in elixir

I wanted to start with the TUI, and then display the top 10 Hacker News posts.
This seemed simple enough with my constraints.

Long story short, it scaffolds the app quite effectively.
The first library it picks seems fine.
I had told it specifically to handle a premise of something similar to h1/h2/h3 being denoted in the text, as if I was rendering markdown. It started with a super basic hand rolled parser, and then I had it add a library.
This all felt pretty pedestrian from what I'd seen with an LLM, but I will say, it did manage to get it all together in a total of 2 short sentences.

My next goal was just to run what was thrown at me. But, check out `An Aside: Python Issues` at the bottom for more on reasoning with the LLM through actual runtime issues and not building something with code.

I knew this whole library could eventually work, but after a bunch of back and forth, decided to tell the model that now that it knew the idea of what I needed and had one implementation to iterate upon.

Let's take a look at how the machine was responding to me from 0 up until this point of having a 'working' ratatouille app (that I never got to truly run).

What I really am looking for is if the machine seems to be learning from its prior inputs and thoughts on how I'm telling it to build as it formulates plans and makes choices while I tell it what to spit out for me.

It immediately gave me a working TUI prompt.

So my code in a single gist would be something like

```elixir
Mix.install(  [
    {:ratatouille, "~> 0.5.0"}
  ]
)

defmodule MyTui.Runner do
  def start do
    Ratatouille.run(MyTui)
  end
end

defmodule MyTui do
  use Ratatouille.App

  # Called once when the app starts up
  def init(_context) do
    # This returned struct becomes your initial model
    %{message: "Hello from TUI land!"}
  end

  # Called whenever there's a new event (keyboard, etc.)
  def update(model, msg) do
    case msg do
      # If the user hits 'q', let's quit
      {:event, %{ch: ?q}} ->
        :quit

      # Otherwise, just pass the current model along unchanged
      _ ->
        model
    end
  end

  # Called on every “frame” to render your UI
  def render(model) do
    view do
      panel title: "My Elixir TUI" do
        label(content: model.message)

        label(content: "Press 'q' to exit",
              color: :blue)
      end
    end
  end
end

MyTui.Runner.start()
```

Now, this was a start. But next I needed something more.
I wanted to display Hacker News top stories, not some fixed text.

#### Building A TUI
Now, I wanted to give it a task I thought would be an easy swish for even an older model from what I'd heard.
I didn't have massive expectations, but grabbing 10 HN headlines is pretty trivial stuff.
So, here we are beginning to really talk about the client and the higher order application that we are making.

Oh, but wait, the model throws out some more thoughts without prompt at the end of the first thoughts to get all this out:


> in this TUI, I want to take a list of maps like this:

> `[%{title: "An awesome TUI in Elixir", body: "# Hi\n##This is a TUI"}]`

> And then display them so that the TUI displays the body key, but making the text with # tags for markdown big like an h1 and the ## ones an h2 style display size etc

That is nothing too crazy, but its a start to tell it what my bigger goals are.
What this is really doing is trying to create a 'seam'.
Somewhere that within my own control I will be able to just place in a feed of titles and if it is the right shape it works.
Soon this will become a Hacker News client proper, but let's see how it thinks about this all initially.

What I have really asked it to do is visually create characteristics that represent h1 h2 and h3.
It has figured out how to do this with a combination of colors/bold/underlining.
Now, this seems fine to me.
And it is interesting that the model is successfully getting this part right so fast.

Next, I tell it that it should refine the markdown parser that it uses for this.
Rather than relying on pattern matching, use a library.
Here is the exact prompt:

> lets refine the markdown parser to use a library. It will wrap the library to make the font sizes bigger in ratatouille one way or another, based on which type of h tag it gets parsed to from the markdown library

Now, before we dig into this, I am going to make a git repository that follows along with all of this and has each phase.

We can begin with [this commit](https://github.com/notactuallytreyanastasio/tui_from_ai/tree/0b84f3127319a9d00569d9db1c6407bab5e3588e)

This is the first TUI where we have issues getting it to run, but see the fundamental outline get reached.

Now, the next phase is going to be getting a _truly_ working TUI.
Let's get some stuff on a page.

The prompt for that came here:

> scaffold me out something using another TUI with a totally fresh project that just displays "big ole musky glitter bunnies" in bold text.

The reason I went for something so simple is I just wanted to see some stuff on a page after losing ~30 minutes to compilation back and forth and Python version juggling.
This went well enough, so I had my other working part, and I finally was in a discussion about if I stick with the TUI library I had, or if I move onto a new one.
As we said, I decided, after some back and forth with it, I will pursue a new library for the TUI. And this pretty much gets me there.

Now, we can begin really cooking.

The diff can be found [here](https://github.com/notactuallytreyanastasio/tui_from_ai/commit/b6447f06ea8f9494bc12747ac7cb19a7aaa46fac).

But, we do have some stuff on a screen.
Albeit, with a weird error message log, and its not exactly centered or even huge.

But, its bolded text and we are now using NCurses and not whatever was under the hood before.

<img width="566" alt="Screenshot 2025-01-08 at 7 23 19 PM" src="https://github.com/user-attachments/assets/47be023f-6534-4446-9079-9e97bb70336e" />

With this, I can begin the next real steps of work.

#### A Hacker News Client
> Now, I want you to build a quick client to get the top ten hacker news stories headlines.

This was all I gave it, and it spit out just what I needed.

I got a new `mix.exs` with req and whatever else, and then it could grab ten headlines.

The code looks straightforward enough.
They could have extracted a base URL, showed some other endpoints, but as a starting unit it works.
[This commit](https://github.com/notactuallytreyanastasio/tui_from_ai/commit/bc219a65a2bf265e45dd0c4b162ef41d2e75c62f) holds it, but its small enough we can just look here:

```elixir
defmodule HnClient do
  @moduledoc """
  Fetches top stories from Hacker News and prints the first 10 headlines.
  """
  def fetch_top_10 do
    # 1. Get a list of top story IDs from the Hacker News API
    top_ids =
      Req.get!("https://hacker-news.firebaseio.com/v0/topstories.json")
      |> then(fn %Req.Response{body: body} -> body end)
      # Body is a huge list of story IDs, so we'll take the first 10
      |> Enum.take(10)
    # 2. For each ID, fetch the story data
    top_stories =
      top_ids
      |> Enum.map(fn id ->
        Req.get!("https://hacker-news.firebaseio.com/v0/item/#{id}.json").body
      end)
    # 3. Extract the "title" from each story
    # And map them into a nice numbered list
    Enum.with_index(top_stories, 1)
    |> Enum.map(fn {story, i} ->
      "#{i}. #{story["title"]}"
    end)
  end
  def print_top_10 do
    fetch_top_10()
    |> Enum.each(&IO.puts/1)
  end
end
```

If we are connecting dots, we can quickly see how this is going to become a TUI for HN.

Our only thing we are stuck with is NCurses.
The API is pretty simple and can be talked to by anything, but `req` is great.
Alongside that, we just need to loop in those stories and then we have them all on a page.

#### Note: I am omitting a section where I got top comments, it was unexciting and ate a couple minutes

Here, I give it yet another straightforward and short prompt:

> Now that we have a client, let's use the client to get the top ten headlines. Next, in the terminal UI, take each headline, and display it in bold text, with new lines separating them

And we began getting some new files.
It was quickly changing how it accessed HN stories, and then also prepping changes in the TUI.
We can see them in effect with [this commit](https://github.com/notactuallytreyanastasio/tui_from_ai/commit/546915b421b0793879a0a2bea8b07b8d64eb01f9) or in the screenshot below:

<img width="553" alt="Screenshot 2025-01-08 at 7 35 15 PM" src="https://github.com/user-attachments/assets/edf4a35f-5905-4153-b5a0-94bfedbe45b8" />

Now, all of this is working pretty great and I think we're over the hump of things not working in general.
I waste some time having the client grab top comments for each post, and I have it start to illsutrate the seam between displaying "something" and it having to be a post that is a string or whatever there.
This all seems great.
Next, it took me through problems getting NCurses to scroll.
My version's bindings were bad, and nothing was gonna ugprade this 6 year old NIF that was making it run.

So, after more discussion, we got to the final solution.

I wanted it to roll its own TUI library.

#### Rolling our own TUI library
#### Thinking About Scrolling
#### Reflecting On 3 Iterations and Improving
#### Round 1 Refactoring
#### Round 2 Tests
#### Bonus Round: Show it feeding live, in a web app
#### An Aside: Python Issues


### Reflections On The LLM As A Tool

### Conclusion



# Usage
Get the top HN stories and then their top comment.

Rolled out with its own TUI.

Check git history for ncurses and ratatoullie variants.

## Made all using GPT 4o. No manual code modification, only copy/paste

```elixir
GlitterTui.start
```
