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

#### Building an HN Client
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

So, first and foremost, let me create that in a new repo rather than here, where I have a messier history.
We will be rebuilding this all from scratch except for the first TUI we pitched.

#### First TUI
#### A New TUI Library (NCurses)
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
