## # STS 98 - Lecture 2016.04.05
##
## Also see the [R output](r_session.txt). These notes are just a rough outline
## of what we discussed in class; some topics may be missing.

## Logistics
## ---------
## The Wednesday 1:10 pm discussion will be in Surge III 1283.
##
## The Wednesday 2-4 pm office hours will be in Kerr 165.
##
## The Friday 1-3 pm office hours will be in SSH 1246.


## R ignores lines starting with the # symbol. These are called comments. Use
## comments to plan out what you're trying to do, and to explain tricky pieces
## of code.


## Inspecting Data
## ---------------
## Last time we looked some functions for changing R's working directory:
##
## * getwd(), setwd(), list.files()
##
## Then we loaded an RDS file with `readRDS()` and looked at some functions for
## inspecting the structure of a data set:
##
## * head(), tail()
## * nrow(), ncol(), dim()
## * str()
## * typeof(), class()
## * rownames(), colnames(), names()
## 
## We also saw some functions for inspecting the content of a data set:
##
## * $ operator, to extract a column
## * table()
## * sort()
##
## Let's start with a few more of these.

x = readRDS("data/sts98.rds")

## This data set has everyone's class level, major, and department. We can get
## a quick summary of the data with the `summary()` function:

summary(x)

## This data set only has categorical information, so we just see counts. Last
## time we saw that the `table()` function computes counts, too. Unlike
## `summary()`, the count for every category is computed:

table(x$Major)
sort(table(x$Major))

## You can also use `table()` to count how many observations fall into pairs of
## categories, across two columns. This is called _cross-tabulation_. For
## instance, we can cross-tabulate class level and major:

table(x$Class, x$Major)

## This gives us a very detailed breakdown of the data. Like any other value in
## R, we can save this to a variable. The `addmargins()` function adds row and
## column sums to the table:

ctab = table(x$Major, x$Class)
addmargins(ctab)

## It's a good idea to use variables to save intermediate steps in your code so
## that if something goes wrong, you can figure out where the problem is.

## __Q:__ What happens if we sort the cross-tabulated values?

sort(table(x$Class, x$Major))

## This is probably not what we want. The counts in the table get sorted from
## smallest to largest, but the row and column names are blown away! The
## `sort()` function only works well on vectors. Later on we'll learn how to
## sort a table.

## Here's an example of `addmargins()` for a smaller part of the data:

# Get first 10 rows.
y = head(x, 10)

# Remove categories that aren't present in the first 10 rows; otherwise R
# remembers them.
y$Class = factor(y$Class)
y$Major = factor(y$Major)

# Cross-tabulate and add the margins.
table(y$Class, y$Major)
addmargins(table(y$Class, y$Major))

## File Formats
## ------------
## Data can be stored in many different formats. Most of the time, file names
## end with a dot followed by 3 or more letters. This is called an _extension_
## and indicates the format of the file.
##
## R understands many different formats. In this class we'll see:
##
## Format                       | Extension | R Function
## ---------------------------- | --------- | ----------
## R data                       | .rds      | readRDS
## R data                       | .rda      | load
## Comma-separated values (CSV) | .csv      | read.csv
## Tab-separated values (TSV)   | .tsv      | read.delim
## Plain-text tables            |           | read.table
##
## The extension is just a hint! Sometimes it may be incorrect or misleading.


## For the rest of this lecture, we'll use the NOAA Significant Earthquakes
## Database. There's a download link in the `data/` directory of the lecture
## notes.
##
## Despite the `.txt` extension, this is a TSV file, because:
##
## 1. The download page says it's a "tab-delimited format".
## 2. Opening the file in a text editor shows tabs between the columns.

x = read.delim("signif.txt")

## This is a much larger data set than the STS 98 roster.

dim(x)
names(x)

## The `names()` function is unusual because it also allows us to change the
## names. Let's change them to lowercase to save some typing.

names(x) = tolower(names(x))

## Missing Values
## --------------
## First of all, do you notice anything confusing about this data set?

str(x)

## A lot of values show up as NA. NA is a special value in R that represents
## missing data. In other words, NA means no measurement was recorded. This is
## common in real data sets.
##
## For instance, in the earthquake data, details are scarce on earthquakes that
## happened thousands of years ago.
##
## With the `table()` function, you can find out how many values are missing by
## setting the `useNA` parameter to `'always'`:

table(x$intensity, useNA = 'always')

## Many other functions have options for handling NAs as well. For instance, an
## inspection function we didn't discuss yet is `range()`. It just reports the
## smallest and largest values in a vector.

range(x$year)

range(x$intensity)
range(x$intensity, na.rm = TRUE)

## The reasoning is that if there are unknown values, the range is unknown. So
## we have to explicitly tell `range()` to ignore unknown values.

## __Q:__ What's the type of NA?
##
## __A:__ It depends. By default it's logical:

typeof(NA)

## But NA can be converted to any type, to match other data in a vector. For
## instance, the NAs in the intensity column are integers:

head(x$intensity, 1)
typeof(head(x$intensity, 1))

## If we only need to check the number of NAs, there's an alternative to
## `table()`. The `is.na()` function returns TRUE or FALSE whether the elements
## of the parameter are NAs. 

is.na(NA)
is.na(5)
is.na(c(NA, 4, 18, NA))
is.na(x$intensity)

## Since R represents TRUE as 1 and FALSE as 0, we can sum up the TRUES and
## FALSES to get the number of NAs:

sum(is.na(x$deaths))

## __Q:__ What if we want the number of values that aren't missing?
##
## __A:__ There are three ways to do this. Number of observations minus number of
## missing values:

nrow(x) - sum(is.na(x$intensity))

## Number of values minus number of missing values:

length(x$intensity) - sum(is.na(x$intensity))

## Number of values that are not (! means "not") missing:

sum(!is.na(x$intensity))

## Subsets & Conditions
## --------------------
## We can use functions we learned before to find out which countries had the
## most earthquakes:

tail(sort(table(x$country)))

summary(x$country)

## What if we just want data on USA earthquakes? The `subset()` function lets
## us take a subset of rows. The first parameter is a data set, and the second
## parameter is a condition.

x_us = subset(x, country == "USA")

## Since `=` already stands for assignment, R uses `==` to stand for equality.
## The result is TRUE or FALSE vector.

5 == 5

5 == 6

c(6, -2, 8) == c(6, 3, 8)

## Notice that we can also compare a vector against a single value:

c(6, -2, 8) == 8

8 == c(6, -2, 8)

## This is called _recycling_, because the single value gets reused for each
## comparsion. We didn't discuss it before, but all vectorized R functions
## recycle:

8 + c(2, 4, 6)

## __Q:__ How can we combine conditions? What if we want quakes that happened
## in the USA or happened before year 0?
##
## __A:__ Use a logical operator like | ("or") or & ("and"). These are
## discussed later on in the notes.

## Condition to get quakes before year 0:
##
##     year < 0
##
## Get quakes that are in USA or before year 0:

x_us_bc = subset(x, country == "USA" | year < 0)

## __Q:__ Can we save conditions in a variable?
##
## __A:__ Yes. Let's say we wanted to get a count of how many quakes happened
## before year 0. Then:

from_bc = x$year < 0

# Before year 0.
sum(from_bc)

# After year 0.
sum(!from_bc)

## Now we've seen `==` and `all()` for working with comparisons, but there's
## several other useful functions:
##
## * Comparisons: ==, <, >, <=, >=
## * Logic Operators
##     * or: |, ||
##     * and: &, &&
##     * not: !
##     * quantifiers ("how many"): any(), all()
##
## Let's look at some examples.

## For `|`, left OR right must be TRUE to get TRUE:

TRUE | FALSE

c(TRUE, TRUE, FALSE, FALSE) | c(TRUE, FALSE, TRUE, FALSE)

# Get quakes from year -2150 OR in Jordan. Either or both conditions must be
# true.
subset(x, year == -2150 | country == "JORDAN")

## For `&`, left AND right must be TRUE to get TRUE:

TRUE & FALSE

c(TRUE, TRUE, FALSE, FALSE) & c(TRUE, FALSE, TRUE, FALSE)

# Get quakes from year -2150 AND in Jordan. Both conditions must be true.
subset(x, year == -2150 & country == "JORDAN")

## Beware! The `||` and `&&` operators are faster but only check the first
## element:

c(TRUE, FALSE, TRUE) || c(TRUE, FALSE, FALSE)

## The not operator returns the opposite:

!TRUE
!c(TRUE, FALSE)

## Also note we can abbreviate TRUE and FALSE as T and F:

T | F

## It's safer to use TRUE or FALSE, because T and F are just variables and can
## be assigned other values:

T = 6

## __Q:__ Can I reset T and F?
##
## __A:__ Yes, use `rm()` to remove a variable assignment.

rm(T)

## TRUE and FALSE are special values in R; the logical operators don't work on
## strings:
"TRUE" | "F"

