# A Senior Developer's First Earnest Attempt At Making An App With AI
## Purpose
This is met to be a couple things.

1. A guide for someone totally fresh on LLMs to get started doing something real with one
2. Be a look at how these things work and reason and might tie into a senior developer's workflow
3. Be some commentary on all of this stuff and how it works, and share my thoughts and curiosities

I do this by building a TUI for the top 10 Hacker News stories, getting through 3 iterations, then adding some larger features.

### This is all from reviewing a Chat GPT o1 model chat you can [see here](https://chatgpt.com/share/677dd787-c3c8-8006-a232-e5797090bb6f).

I want to see how these models reason, and how I can work with them in a larger sense.

It's also a fun way to kill several hours.

My initial iteration took 1 hour including all the time spent down the python.

Then, we built it out in NCurses.

Then we rolled our own TUI.

Then, we dropped in a live storage of the data and a web UI to display it using the same client.

The document from here on out is an exploration that kind of covers what I'm outlining here.

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
#### An Aside: Python Issues
#### Building an HN Client
#### First TUI
#### A New TUI Library (NCurses)
#### Rolling our own TUI library
#### Thinking About Scrolling
#### Reflecting On 3 Iterations and Improving
#### Round 1 Refactoring
#### Round 2 Tests
#### Bonus Round: Show it feeding live, in a web app

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
