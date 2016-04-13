# Week 2 Update #

Hi Terry! Hope you're doing well. Just checking in to give you an update on my progress on Nosko.

### WIM Requirement ###

I’m a huge believer in writing as a way to explore ideas as much as medium for communicating with others. As a commitment mechanism for practicing what I preach, I’ve signed up for the “W” version of CS191, though I’ve already fulfilled my WIM requirement.

The first step is to decide on the topic/format of the writing assignment. I’m thinking of writing a sort of “manifesto” on Tools for Thought rather than a technical summary of what I’ve done, because I think that’s a lot more interesting and meaningful, though I’ve yet to decide where I would begin. **I’d love to hear your thoughts on this idea and any expectations you might have for the assignment.**

### Summary of Week 2 ###

My main focus this week was ensuring that Nosko “findings” retrieved from Evernote are consistent with the state of notebooks in Evernote database. This had a number of different steps:

**1. Extractor Redesign**

After a long, fruitful conversation about API design with [John](twitter.com/backus), I completely overhauled my models and methods for extracting articles from various sources. I had previously written a single `Article` class. The initialization of a new `Article` required me to specify the source as an argument, and it then retrieved the data from that source. It then saved this data into the db along with a `:source` attribute to store that origin and its `api_token` (or whatever unique id required by the source to retrieve that resource).

I refactored this into a series of classes that each "own" a different step of this process. The `Article` model now just contains the information common to all articles, regardless of their source. The classes within the `Extractor::Article` module (`Evernote`, `Instapaper`, `Readability`) handle all of the retrieval logic, including the parsing steps unique to each particular source. This has two key benefits:

1. By separating the retrieval and record logic, clients of a particualr class can ignore the implementation details of the other. From the user's perspective, `Article`s are supposed to be agnostic to their original source. But before, when displaying an `Article` in views, retrieving records (through something like `Article.all`) we'd get back a ton of information like `api_token` and `source` (to keep track of record retrieval from the original source), which are't really relevant to the user's experience of an `Article`. Now, retrieving `Article` records for viewing hides all of the retrieval complexity, which can be explicitly called upon within syncing functions.

2. It keeps the `Article` model from getting "fat" as we add new sources over time. Even with just the first three sources, it required unique handling of each source's `api_token` (`guid`, `bookmark_id`, and `short_url` for Evernote, Instapaper, and Readability respectively), unique parsing for each source, and unique methods for retrieving other metadata from the APIs. This last part is the most important –– each API offers different metadata about its articles, and as a result some methods on the old `Article` class wouldn't be guaranteed to return a value at all! For example, Readability exposes a `date_published` field, but not every Readability article specifies this so sometimes it returns a `DateTime` object and sometimes it returns `nil`; meanwhile, Instapaper doesn't offer this field at all, so it would always return `nil`. However, the meaning of `nil` from Readability is very different from a `nil` returned by an `Article` sourced from Instapaper. By separating this extraction into separate classes for each source independent from the `Article`, the behavior for the methods on each class in the `Extraction::Article` module is well-defined.

```ruby
module Finding
  Article
    :source_url             => :string
    :title                  => :string
    :content                => :text
    :permalink_id           => :foreign_key
    :user_id                => :foreign_key

module Extractor::Article
  Evernote
    :guid                   => :string
    :last_accessed_at       => :datetime
    :article_id             => :foreign_key
    :evernote_account_id    => :foreign_key
  Instapaper
    :bookmark_id            => :string
    :last_accessed_at       => :datetime
    :article_id             => :foreign_key
    :instapaper_account_id  => :foreign_key
  Readability
    :short_url              => :string
    :last_accessed_at       => :datetime
    :article_id             => :foreign_key
    :readability_account_id => :foreign_key
```

**2. Background Jobs**

I set up a queue to create, enqueue, and execute background jobs in parallel. I implemented `SyncEvernoteAccount` (which retrieves all Evernotes that belong to a particular account that have been created/updated since last sync), `SyncEvernoteNote` (which sets off a job to extract the note corresponding to a given guid), and `ExtractArticleFromEvernote` (which extracts the note corresponding to a given guid).

I used a tool called [`Que`](https://github.com/chanks/que), an alternative to Rail's DelayedJob which uses PostgreSQL's advisory locks for speed and reliability. My infrastructure is currently functional, but for some reason that I need to debut it's extremely slow and crashes when processing large numbers of jobs. I may migrate over to some other framework, replacing `Que` with [`DelayedJob`](https://github.com/collectiveidea/delayed_job) or [`ActiveJob`](http://edgeguides.rubyonrails.org/active_job_basics.html).

### Plans for week 3 ###

I plan to implement:

- user profile pages
- basic feed
- a followers mechanism
  + first I need to decide what model I want to use –– does one need the others' consent / invitation to follow their findings feed (more similar to Facebook)? or should everything be public by default, though people can have private profiles (more like Twitter)? or something totally different?

That should be enough to bite off for this week. If I have spare time I will also begin working on implementing the sharing mechanisms. The key feature here is a daily email summarizing what was automatically published on behalf of the user and a link to publish those posts that are not automatically public.

Best,
Devon