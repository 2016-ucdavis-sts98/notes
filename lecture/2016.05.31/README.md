# STS 98 - Lecture 2016.05.31

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Announcements
-------------
Shaun will have extra OH tomorrow 5-7pm in Shields 360.

I will have extra OH Thursday 5-6pm in Shields 360.


Questions
---------


Web Scraping
------------
_Scraping_ a web page means extracting information so that it can be used
programmatically (for instance, in R).

The major web scraping packages for R are `xml2` and `rvest`. The former has
general-purpose scraping functions and the latter has functions for common
tasks like scraping tables.

```r
#install.packages("xml2")
#install.packages("rvest")

library("xml2")
library("rvest")
```

You need to know a little about how web pages work before you can scrape
one.

Web pages are written in _hypertext markup language_ (HTML).

Despite the fancy name, HTML is simple. The idea is that text can be
formatted or "marked up" by surrounding it with a pair of _tags_.

Each tag has a name surrounded by angle brackets. Most tags come as a pair.
For instance, the emphasis tag is

    <em><strong>This text</strong> is emphasized.</em> Not emphasized

The first tag is called the _opening_ tag and the second is called the
_closing_ tag. Closing tags mark the end of a format and always start with a
forward slash.

Tags may have _attributes_ after the tag name for additional customization.
For instance,

    <a href="http://www.google.com/" id="mytag">My Search Engine</a>

The `a` stands for "anchor" and is used to create a link. The url for the
link is specified with the `href` attribute.

Here's a simple web page:

    <html>
      <head>
        <title>This is the page title!</title>
      </head>
      <body>
        <h1>This is a header!</h1>
        <p>This is a paragraph.
          <a href="http://www.r-project.org/">Here's a website!</a>
        </p>
        <p>This is another paragraph.</p>
      </body>
    </html>

In most web browsers, you can examine the HTML for a web page by
right-clicking and choosing "View Page Source".

```r
doc = read_html("data/example.html")
doc

# Get tags nested inside the top-level tag.
head = html_children(doc)[[1]]
title = html_children(head)
html_text(title)
```

Navigating the tags by hand is tedious and easy to get wrong!

Press `Ctrl + Shift + c` in Firefox or Chrome to open the web page developer
tools and locate the tag you want. Right-click the tag and choose "Copy
Unique Selector". This gives you a _CSS selector_ that identifies the tag.

See <http://flukeout.github.io/> for a tutorial on CSS selectors.

```r
para = html_node(doc, "body > p:nth-child(3)")
html_text(para)

# Get all links in a page.
links = html_nodes(doc, "a")

# Get all paragraphs.
html_nodes(doc, "p")

# Get just one paragraph.
html_node(doc, "p")
```




Now let's scrape a table from Wikipedia.

```r
wiki_url =
  "https://en.wikipedia.org/wiki/List_of_cities_and_towns_in_California"

doc = read_html(wiki_url)

wiki_tab = html_node(doc, "table.wikitable:nth-child(20)")
html_text(wiki_tab)

# Convert an HTML table to a data frame.
cities = html_table(wiki_tab, fill = TRUE)
```

__IMPORTANT:__ downloading a web page is not free! Be considerate of authors
and minimize the number of times you download each page.

It's easy to save a downloaded web page for repeated use:

```r
saveRDS(doc, "wiki.rds")

write_xml(doc, "wiki.html")

# The danger is mainly with loops and apply functions:
sapply(1:20, function(x) {
  # Don't scrape in a loop like this without a delay.
  read_html("http://www.google.com")
  Sys.sleep(1) # delay 1 sec
})
```

Also keep in mind that many prominent web pages such as Amazon do not allow
scraping! They will block you if you violate their terms of use.


Data Cleaning
-------------
We got our table, but now we need to clean it up.

```r
# Fix column names.
names(cities) = c("city", "type", "county", "population", "mi2", "km2", "date")

# Remove fake first row.
cities = cities[-1, ]
# Reset row names.
rownames(cities) = NULL
```

How can we clean up the "date" column?

The `substr()` function can extract part of a string.

```r
substr("hi sts 98", 4, 6)

# Get characters 9-18.
dates = substr(cities$date, 9, 18)
head(dates)
tail(dates)
dates = as.Date(dates)
cities$date = dates
```

We can also convert the population to a number.

```r
mean(cities$population, na.rm = T) # doesn't work
class(cities$population)

pop = gsub(",", "", cities$population)
pop = gsub("[9]", "", pop, fixed = TRUE)
pop = gsub("[10]", "", pop, fixed = TRUE)
pop = as.numeric(pop)
head(pop)
table(pop, useNA = 'always')

# Figure out why some were NA.
which(is.na(pop))
cities[199, ]

cities$population = pop

sapply(cities, class)
```

For more sophisticated strings, it's often easiest to use regular
expressions. See <http://regexone.com/> for a tutorial.



Cleaning often takes up 80% of the time spent on data analysis. There are
several packages to help out:

Package   | Purpose
--------- | -------
tidyr     | data tidying reduced to 2 verbs
dplyr     | data manipulation reduced to 4 verbs
stringr   | string manipulation
lubridate | date manipulation

Base R has functions to do all of these things, but these 4 packages are
designed to work together seamlessly with each other and with ggplot2. They
are sometimes called "the Hadleyverse" after their creator, Hadley Wickham.


Geocoding
---------
Getting the longitude and lattitude for an address is called _geocoding_.

The ggmap package can geocode addresses with Google Maps. However, Google
only allows 2500 requests per day.

Let's geocode 5 cities.

```r
# Install before loading!
library("ggmap")

# Format addresses from the city names.
addr = paste(cities$city, ", CA", sep = "")
first5 = head(addr, 5)

gcodes = geocode(first5)
gcodes

# Bind longitude and latitude columns to the data frame.
cbind(first5, gcodes)

geocode("1 Shields Ave, Davis, CA")
geocode("Univerity of California, Davis")

# Google Maps only allows 2500 requests per day!

```

Politico Example
----------------
See the [politico.R](politico.R) file!


dplyr
-----
The dplyr package reduces data analysis to 4 verbs:

Verb      | Description              | Functions
--------- | ------------------------ | ---------
arrange   | sort rows                | arrange()
filter    | remove rows or columns   | filter(), slice(), select(), distinct()
mutate    | create or rename columns | mutate(), transmute(), rename()
summarize | aggregate rows           | summarize()

These are not too different from what we've already learned.

The `summarize()` function is a nice alternative to the split-apply
strategy, especially when used with dplyr's `group_by()` function.


```r
library("dplyr")

summarize(group_by(cities, county), pop_mean = mean(population),
  pop_med = median(population), pop_sum = sum(population))

# The same as:
tapply(cities$population, cities$county, mean)
tapply(cities$population, cities$county, median)
tapply(cities$population, cities$county, sum)
