## # STS 98 - Lecture 2016.04.21
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Questions?
## ----------
##
## __Q:__ How to combine categories in a categorical variable?
##
## __A:__ Use the `levels()` function to reassign the categories.

x = c("Cat", "Dog", "Ferret", "Iguana", "Cat")
x = factor(x)
x
levels(x) = c("Cat", "Dog", "Other", "Other")
x

## Choosing Plots
## --------------
## What plot should you use?
##
## Variable    | Versus      | Plot
## ----------- | ----------- | ----
## numerical   |             | box, histogram, density
## categorical |             | bar, dot
## categorical | categorical | mosaic, bar, dot
## numerical   | categorical | box,  density
## numerical   | numerical   | scatter, smooth scatter, line
##
## If you want to add:
##
## * 3rd numerical variable, use it to change point/line sizes.
## * 3rd categorical variable, use it to change point/line styles.
## * 4th categorical variable, use side-by-side plots.
##

## Relationships Between Variables
## -------------------------------

w = read.csv("data/noaa_daily.csv")
head(w)

## Let's make a line plot of Davis and Death Valley temperatures against time.
## This is (tmax vs time vs station), which is (numerical vs numerical vs
## categorical).

davis = subset(w, station == "Davis, CA")
dv = subset(w, station == "Death Valley, CA")

plot(tmax ~ date, davis, type = 'l')

## This takes a long time to plot, and the x-axis looks strange. That's a hint
## that something went wrong.

typeof(davis$date)
class(davis$date)

## R uses the class `factor` for categorical variables, but dates aren't
## categorical.
##
## Why does R think the date column is categorical? The weather data was stored
## as text in a CSV file! R doesn't automatically recognize text as dates.
##
## To convert the date column to dates, use `as.Date()`:

d = as.Date(w$date)
head(d)
head(w$date)
class(d)

w$date = d

davis = subset(w, station == "Davis, CA")
dv = subset(w, station == "Death Valley, CA")
class(davis$date)

plot(tmax ~ date, davis, type = 'l')

## How does `as.Date()` work? We can use it to convert just about any date.
## The syntax is:
##
##    as.Date(x, format)
##
## The parameter `x` is a string to convert to a date. A _string_ is just
## another word for quoted text.
##
## The parameter `format` is a string that explains how the date is formatted.
## In the format string, a percent sign `%` followed by a character is called a
## specification and has special meaning. The most useful are:
##
## Specification | Description      | January 29, 2015
## ------------- | ---------------  | ----------------
## %Y            | 4-digit year     | 2015
## %y            | 2-digit year     | 15
## %m            | 2-digit month    | 01
## %B            | full month name  | January
## %b            | short month name | Jan
## %d            | day of month     | 29
## %%            | literal %        | %
##
## For more, see `?strptime`.
##
## Some examples:

as.Date("January 29, 2015", "%B %d, %Y")

as.Date("01292015", "%m%d%Y")

as.Date("01%13%3013", "%m%%%d%%%Y")

x = c("Dec 13, 98", "Dec 12, 99", "Jan 1, 16")
class(x)
y = as.Date(x, "%b %d, %y")
class(y)
y
# You can do arithmetic on dates.
y[2] - y[1]

## Let's get back to the plot.

r = range(davis$tmax, dv$tmax, na.rm = T)

plot(tmax ~ date, davis, type = 'l', ylim = r, main = "Max Temp for Davis &
  Death Valley", ylab = "Max Temp (F)", xaxt = 'n')
# xaxt is from ?par

lines(dv$date, dv$tmax, lty = "dashed", col = "blue")

legend("bottomleft", c("Davis", "Death Valley"), lty = c("solid", "dashed"),
  col = c("black", "blue"), cex = 0.5)

## The `seq()` function makes a sequence. The syntax is
##
##     seq(from, to, by)
##
## where `from` is the starting number, `to` is the ending number, and `by` is
## how many to count by. There are also other parameters, and the function
## works for dates.

seq(1, 10)

seq(1, 10, 4)

# seq() works with dates
at = seq(as.Date("2013-01-01"), as.Date("2016-12-31"), "quarter")
axis(1, at, as.character(at))

## What does the plot tell us?
##
## Seems like Death Valley has winters similar to Davis despite being much
## hotter in summer. The variation in temperature is higher for Death Valley.

sd(davis$tmax)
sd(dv$tmax, na.rm = T)

## Is there a relationship between wind speed and minimum temperature?

plot(awnd ~ tmax, w)

## Some of the points get plotted on top of each other. This is called
## _overplotting_.
##
## Plots with lots of overplotting can be hard to read and misrepresent the
## data by hiding how many points are present.
##
## Blurring the points makes the plot easier to read and reveals where the most
## points are:

smoothScatter(w$tmax, w$awnd)

## Is there a strong relationship or not?
##
## Sometimes it's possible to see a relationship, but this does not imply
## causation!

## How many days were hot in each location?

(w$tmax + w$tmin) / 2
# with() lets you avoid typing w$ over and over.
w$temp = with(w, (tmax + tmin) / 2)

w$temp_cat = cut(
  w$temp, c(-Inf, 32, 68, 80, Inf), c("Freezing", "Cold", "Nice", "Hot")
)

table(w$temp_cat)

tab = table(w$station, w$temp_cat)

## Mosaic plots are a good way to plot two categorical variables against each
## other. They work best if there aren't too many categories (< 7) for each
## variable.

mosaicplot(tab)

mosaicplot(station ~ temp_cat, w, las = 2, cex.axis = 1.4)


## R Packages
## ----------
## An R _package_ adds more functions to R. Anyone can write an R package.
##
## The _Comprehensive R Archive Network_ (CRAN) is a collection of packages for
## R.
##
## It's easy to download and install an R package:

install.packages("RColorBrewer")

## You only need to download and install the package once. You can update the
## package by reinstalling.
##
## R doesn't load the package automatically. You can load a package with the
## `library()` function. You need to do this each time you restart R and want
## to use the package.

library("RColorBrewer")

## Packages on CRAN always have documentation explaining how they work.
##
## The RColorBrewer package is designed to help you choose colors for your
## graphics, with the help of the website colorbrewer2.org.

rdpu = brewer.pal(3, "RdPu")
rdpu[3]

## The package returns _hexadecimal_ color codes. You can use these with any of
## R's plotting functions.

plot(tmax ~ date, davis, col = rdpu[3])

## Grouping - Lattice
## ------------------
## What if we want to plot temperatures for all of the stations against time?
##
## With the built-in plotting functions, we'd have to compute a subset and add
## a line separately for each station. One of the main reasons for using R is
## to avoid doing redundant work like this.
##
## The lattice package can help. It's included with R, so we don't need to
## install it. We do have to load it, though.
##
## Lattice has plotting functions similar to R's built-in plotting functions.
##
## R Built-in      | Lattice
## ----------      | -------
## plot()          | xyplot()
## barplot()       | barchart()
## dotchart()      | dotplot()
## boxplot()       | bwplot()
## hist()          | histogram()
## plot(density()) | densityplot()
## 
## All of the lattice functions use formula notation:
## 
##     y ~ x | group
##
## The "group" in the formula makes side-by-side plots, with one for each
## group. Sometimes side-by-side plots are called _faceted_ plots.

library("lattice")
xyplot(tmax ~ date | station, w, type = 'l')

## The lattice functions also a have a separate groups parameter for marking
## groups within a single plot.
##
## Setting the `auto.key` parameter to `TRUE` tells lattice to add a legend.

xyplot(tmax ~ date, w, groups = station, type = 'l', auto.key = TRUE)

## It's possible to use both groupings at once.

xyplot(tmax ~ date | country, w, groups = station, type = 'l', auto.key = TRUE)

## The drawback of lattice is that LATTICE DOES NOT WORK WITH THE BUILT-IN
## PLOTTING FUNCTIONS!!!
##
## That makes it harder to customize lattice plots.
