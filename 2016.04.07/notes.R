## # STS 98 - Lecture 2016.04.07
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Check out these lecture notes!
##
## Extra office hours today 5-7 pm in Shields 360.

## Subset & Extraction Operators
## -----------------------------
## Back to the NOAA earthquakes data!

q = read.delim("signif.txt")
names(q) = tolower(names(q))
q = quakes

## Which country has the most earthquakes?
##
## If we want to sort the table, use `sort()` after using `table()`.

sort(table(q$country))
head(sort(table(q$country), decreasing = TRUE), 5)

## What if we want Chinese earthquakes from the last 200 years?

china200 = subset(q, country == "CHINA" & year >= 1816)

## How can we double-check?

# Check the year.
range(china200$year)

# 3 different ways to check the country.
sort(table(china200$country))

china200$country = factor(china200$country)
table(china200$country)

any(china200$country != "CHINA")

## Were any of these tsunamis?

colnames(china200)
levels(china200$flag_tsunami) = c("Quake", "Tsu")
head(china200$flag_tsunami, 20)

## What if we want a TRUE/FALSE for whether any are tsunamis?

is_tsu = china200$flag_tsunami == "Tsu"
any(is_tsu)
all(is_tsu)

## This data set is huge. How can we focus on just the part we're interested
## in?
##
## Use the `select` parameter in the `subset()` function to narrow down the
## columns.

# Cool columns we want to keep.
cool = c("flag_tsunami", "year", "focal_depth", "eq_primary", "country",
  "latitude", "longitude")
cool_q = subset(q, select = cool)

head(cool_q)

## The second parameter (`subset`) in the `subset()` function controls rows,
## while the third parameter (`select`) controls columns.

head(subset(china200, year >= 1916))
head(subset(china200, year >= 1916, select = cool))

## The order of function arguments doesn't matter if you write out the
## parameter names:

head(subset(china200, select = cool, subset = year >= 1916))

## What if we want to select rows and columns at the same time? What if we want
## the first 3 rows and first 3 columns?
##
## Use `[` to select `[ROW, COLUMN]`. Blank means select everything.

q[1, 1] # first row, first column
q[1, ] # first row, all columns
q[, 1] # all rows, first column

q[1:3, c(1, 5)]
q[1:3, ]

q[, 1:3]
head(q[1:3])


q[1] # all rows, first column (data frames are lists)

# What happens with negative indexes?

q[1:3, -1]

## Can we use column names instead of numbers?

q[c(1, 3), c("year", "country")]

## Can we use `[` on a vector? Or is it just for
## data frames?

a = c(5, 8, 2)
a[1]
a[2]
a[3]

## Does `[` work like subset(), where we can use a
## condition?

q[q$country == "CHINA", ]

## TRUE means "keep" and FALSE means "throw away".

q$country == "CHINA"

## Extraction Operator
## -------------------
## It's easy to confuse the subset operator `[`
## with the extraction operator `[[`. There are
## two main differences:
##
## 1) `[[` extracts just one element, whereas `[`
##    can get many.
##
## 2) `[[` peels off lists, whereas `[` keeps them
##
## For example:

q[[1, 1]]

a = list(6, 3, 1)
a[1]
a[[1]]

typeof(a[1])
typeof(a[[1]])

## In a picture:
##
##     a        a[1]     a[[1]]
##     +---+    +---+
##     | 6 |    | 6 |      6
##     | 3 |    +---+
##     | 1 |
##     +---+
##
## Some functions are picky about vectors and
## lists.

## Graphics
## --------
## The `plot()` function accepts a formula as the ## first argument. Formulas
## in R are written ## `y ~ x`, and correspond to the plot axes.

q = quakes
plot(latitude ~ longitude, q)

## What's wrong with this plot?
##
## It should have titles and axis labels. We could also add some color; we can
## list R's built in colors with the `colors()` function.

colors()

plot(latitude ~ longitude, q, col = "plum", main = "Worldwide Earthquakes",
  ylab = "Latitude", xlab = "Longitude")

## This plot doesn't necessarily need a legend, since there's only one kind of
## point, but we could add one with the `legend()` function. The `pch`
## parameter controls the point symbol used in the legend.

legend(-166.7, -36.5, legend = "Earthquake", pch = 1, col = "plum")

## Use the `locator()` function to figure out the coordinates for the legend's
## top left corner.

locator(1)

plot(latitude ~ longitude, q, main = "Earthquakes", xlab = "Longitude",
  ylab = "Latitude")

## How can we visualize which countries have the most earthquakes?

counts = sort(table(q$country))
barplot(counts)

## This is hard to read. We can swap the axes with the `horiz` parameter, and
## rotate the labels with the `las` parameter. The latter is described in
# `?par`.

?par
barplot(counts, horiz = TRUE, las = 1)

## There's still too much on the plot. Let's cut down to the top 10.

barplot(tail(counts, 10), horiz = TRUE, las = 1, xlim = c(0, 1000), 
  main = "Earthquakes", ylab = "Country", xlab = "Number of Earthquakes")

## Does the width of the bars tell us anything?
##
## Not really, so let's dump them.

dotchart(tail(counts, 10), xlim = c(0, 1000))

## How can we show just the top 20%?

top20 = length(unique(q$country)) * .2

top20 = tail(counts, top20)
dotchart(top20)

## The `dotchart()` function is not happy that `top20` has class `array`
## instead of being a vector. We can fix it with the vector creation function
## `c()`.

class(top20)
top20 = c(top20)

## What's still missing?
##
## Every plot should have a title and labels.

dotchart(top10, xlim = c(0, 1000), main = "Top Earthquakes",
  xlab = "Number of Quakes")

## How can we separate regular quakes and tsunami?

tsu = table(q$country, q$flag_tsunami)

## Make the table into a data frame so we can use `$` to extract columns.

tsu = data.frame(Quake = tsu[, 1], Tsu = tsu[, 2])

head(tsu)

## How can we sort 2-dimensional data? The `sort()` function won't work.
##
## Use the subset operator `[` to reorganize rows.

tsu[1:3, ]
tsu[c(2, 3, 1), ]

## We also need a function that can tell us which row goes first, which goes
## second, and so on. That's the `order()` function.

ord = order(tsu$Quake + tsu$Tsu)
tsu[ord, ]

