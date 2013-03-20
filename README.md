# DVD Library

The unimaginatively named Rails app for browsing DVD libraries.

## Why it exists

After yawning my way through a couple of Rails tutorials, I wanted a more effective way to get familiar with Rails development. I have this old Windows program that keeps track of the DVDs and whatnot that I buy, and I've always wanted a nicer way to browse them. This finally gave me an excuse to spend a couple of weeks developing one.

## Try it out

DVD Library is staged at <http://dvds.hx.net.au>.

## How it works

[Invelos DVD Profiler](http://invelos.com/) can export its data as XML, either as one big file, or as one file per title. This app imports the latter.

DVD Profiler also stores cover scans as JPGs. This app can also import those files.

To import titles and cover scans, drop them onto a library's icon, or anywhere in the browser window if a library is already open.

Scroll left and right to browse a library. Enter a search term in the top right to filter the displayed titles.

Some example searches:

 * `star wars` Search for titles containing "star wars"
 * `80-120` Show titles running between 80 and 120 minutes
 * `R` Show titles with R ratings
 * `denzel` Show titles starring Denzel Washington
 * `comedy` Show comedies
 * `blu` Show only blu-ray titles
 
To search by release date or production year, enter a date or year, then use the left/right arrow keys to choose between `before`, `before or on`, `on`, `on or after`, and `after` (clicking a comparison also works).
 
You can also enter sorting criteria, such as `title`, `release-date`, `runtime` etc.

Every time you choose a search/sort token, it'll be displayed in the bottom right. You can use the browser's forward/back buttons to move between sets of tokens.

## Behind the scenes

Look ma, I can make Rails apps! This was a not-for-profit project with very limited development time, so there's plenty on the wish list that didn't make the cut. But first:

### What it's got

In no particular order:

* Templates written in HAML.
* StyleSheets written in SCSS, with plenty of Compass mix-ins.
* Scripts written mainly in CoffeeScript.
* Tests written for Rspec and Qunit.
* Plenty of metaprogramming, including a basic DSL for describing how XML elements map to ActiveRecord properties.
* JavaScript MV* with the Backbone.js library.
* Infinite scrolling effect and lazy loading of images. Achieved by forcing the browser's body width and running the app on top with fixed positioning.
* Aggressive use of Ruby gems:
    * `chronic` for parsing date searches
    * `ruby-tmdb3` and `tvdb_party` for querying the TheMovieDB and TVDb APIs
    * `fastimage` for obtaining remote image dimensions without downloading them
    * `closure-tree` for parent/child relationships between titles in box sets
* Shared client/server side code.
    * Scopes are represented as key/value pairs in URIs, e.g. `release-date-gte/2007/certification/PG/rsort/title`. The parser is written in JavaScript, and runs both client-side (within Backbone's routing system) and server-side through TheRubyRacer's V8 implementation.
* Mostly custom client-side libraries. 
    * I tried using the [filedrop](https://github.com/weixiyen/jquery-filedrop) jQuery plugin for file uploads, but it's quite buggy and a bit unco, so I wrote my own `ondrag`, `upload` and `upload.batch` jQuery plugins. In fact, I'm so happy with them, that I'd like to convert them from quick-and-dirty CoffeeScript to pure JavaScript and release them as open-source.
    * jQuery UI's autocomplete also didn't work out for the search feature, so it's a custom library. The importer progress bar, text scaling, and cover flow style viewer are all custom.
* Some reasonably clever server-side libraries:
    * `NameAndSeason`, which parses titles like “The Office: The Complete Second Season” and returns `{name: 'The Office', season: 2}`
    * `ThirdPartyPoster`, which attempts to track down posters from TheMovieDB and TVDb in place of missing cover artwork.
    * `NumberToEnglish`, which monkey-patches `Numeric` so that `-12.3.to_cardinal` returns “negative twelve point three” `42.to_ordinal` returns “forty-second”. Based on a library I wrote in Visual Basic some fifteen years ago. 
* Plenty of nice CSS3 transitions and effects—hopefully not over-used.
* Nice fonts, thanks to our friends at [Font Squirrel](http://www.fontsquirrel.com/tools/webfont-generator).

And now, before anyone feels the urge to email “constructive criticism”, these are things I'd love to do if I had more time to waste:
 
### What's missing

* *More browser support*. The app is pretty HTML5-heavy and presently only tested in the latest Mac versions of Firefox and Chrome.
* *Comprehensive specs*. Call it sinful or whatever, but staging the app was more important than dotting every i.
* *Cleaner code*. I kept things reasonably sane, but there's a few solid days of basic refactoring needed in there.
* *SQL optimisations*. I could spend hours tweaking joins and `:include`s to reduce the number of database lookups, but it runs well enough for now. 
* *Interfaces for managing libraries*. Libraries need to be managed through the database or the Rails console. This includes creating, deleting, naming, and storing API keys for TheMovieDB and TVDb.
* *Authentication*. There's zero security in this app, since it's not really meant to run on public networks or the internet. Having said that, it's really only vulnerable to relatively harmless misuse.
* *Compressed uploads*. Uploading 2000+ XML files over HTTP can be a drag, especially when browsers impose unpredictable limits on numbers of files that can be dropped at once. A single zip file upload would be cool, but server-side processing can still clock in at 20 minutes or so, so there needs to be some threading/forking/comet-style feedback going on. Alternatively, client-side XML processing would be nice. We can do that now, thanks to HTML5's FileReader. (Incidentally, there is a rake task to import an entire directory of XML files, and another for images.)
* *Smoother scrolling*. It's not too bad on beefy computers, but it could be better. I'd like to try replacing the absolute positioning of thumbnails with floats and margins, to transfer the layout workload from JS to CSS a little bit.
* *A few glitches*. The home page can have some unwanted horizontal scrolling at certain sizes. Sometimes thumbnails ‘stick’ to the left of the focused title view. It's not a perfect app by any stretch. Please understand this was developed over 3 weeks in my very limited spare time, and hasn't undergone the usual QC I apply in most of my work.

## Setup instructions

1. Clone the repo, `bundle install`, and `rake db:setup`. A default library will be created.
1. Add API keys (they're easy enough to get). Easiest is through `rails c`:

    ```ruby
    lib = Library.first
    lib.tvdb_api_key = 'aabbccdd'
    lib.tmdb_api_key = 'eeffgghh'
    lib.save
    ```

1. Run `rails s` and go to <http://localhost:3000> in the latest version of Chrome or Firefox.
1. Drop some XML files into your library (either on the icon at `/` or anywhere in `/libraries/1/titles`). I'll upload a sample batch of XML files at a later date. If you're really keen, I think [Invelos](http://invelos.com) do a free trial.
 
## License

I haven't yet attached a license to this project. It's only been made public for demonstration purposes.
 