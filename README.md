# Nosko #

## Models Structure ##

![](http://i.imgur.com/rTurMFC.jpg)

- The `Finding` module is the group of all of the different types of Findings. They are very similar from the user's perspective, but their internal structure, public-facing methods, and rendering partials are very different. They do share several characteristics – they each must belong to a `:user`, must have a non-blank `:title` and `:source_url`, and they are all [`Permalinkable`](app/models/concerns/permalinkable.rb).
    + `Article` – An HTML-based, web-clipping Finding. It can come from a number of different sources. No matter the original source, it always has a non-blank `:body` attribute. Depending on its original source, it owns metadata in a format unique to that source:
        * `EvernoteArticle`
        * `InstapaperArticle` (not yet implemented)
        * `FeedlyArticle` (not yet implemented)
        * ...
    + `PodcastEpisode` (not yet implemented)
    + `Film` (not yet implemented)
    + `Book` (not yet implemented)
    + ...
- The `User` model contains all of the logic pertaining to a user's login credentials.
    + It has several `*Account`s that handle authentication with external systems:
        * `EvernoteAccount`
        * `InstapaperAccount` (not yet implemented)
        * `FeedlyAccount` (not yet implemented)
        * ...
    + 
- The `Sources` module is the group of all the different types of Sources. From the user's perspective they are all content creators and sources of Findings, but their internal structure, public-facing methods, and rendering partials are very different.
    + `Podcast` (not yet implemented)
    + `Author` (not yet implemented)
    + `Blog` (not yet implemented)
    + ...
- `Permalink` is a general-purpose model that contains a unqiue path for a permanent, shareable resource. Any resource that has a Permalink (including sources, findings, highlights, and annotations) should `include Permalinkable`, a concern that contains logic for retrieving that resource.

## Deployment Pipeline ##

Nosko relies upon Heroku's deployment pipeline. The structure is as follows:

1. Local development.
2. Deploy to `nosko-staging` (staging heroku app) by running [`rb deploy_staging.rb`](deploy_staging.rb).
3. Promote `nosko-staging` to `nosko` (production heroku app) by running [`rb deploy_production.rb`](deploy_production.rb).
