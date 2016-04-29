## # STS 98 - Lecture 2016.04.26
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Announcements
## -------------
##
## Assignment 2 available for pickup in Clark's OH today (Shields 360, 5-7pm).
##
## Midterm next Tuesday. Non-exhaustive topics:
##
## * When to use and how to interpret the plots
##   we've learned
##
## * Elements of a well-formatted plot (axis,
##   title, units, etc)
##
## * When to use and how to interpret mean,
##   median, mode, sd, and IQR
##
## * How to use subset(), [, $, and [[
##
## * Categorical, ordinal, and numerical data
##
## * Logic operators |, &, and !
##
## * Vectorization
##
## On Thursday: review

## Questions
## ---------
## __Q__: How to change axis names on a dot chart?
##
## __A__: yaxt doesn't work with dot plots, so change the name on the table.

dogs = readRDS("data/dogs.rds")

tab = c(table(dogs$breed))
names(tab) = c("Tiny Dog", "Happy Dog", "Fluffy Dog")
tab

dotchart(tab)

names(tab) = NA # turn off names
dotchart(tab)

# In case the margins are too large.
mar = par("mar")
par(mar = c(2, 2, 2, 2))

## Grouping - Split
## ----------------
## How can we compute mean max temperature for every station in the weather
## data?

w = read.csv("data/noaa_daily.csv")

san = subset(w, station == "San Diego, CA")
mean(san$tmax)

## This is obnoxiously repetitive. The computer is supposed to help automate
## tasks!
##
## Who will save us?! It's a bird...it's a plane...it's
##
##     split(DATA, GROUPS)
##
## (The real parameter names are `x` and `f`.)
##
## An example:

spl = split(dogs, dogs$breed)
spl$Poodle

## Now let's try it with the weather data:

spl_w = split(w, w$station)
names(spl_w)

head(spl_w$Barcelona)

# Need to use quotes with $ if there's a space.
spl_w$"Honolulu, HI"
# [[ is the same as $ but always requires quotes.
spl_w[["Honolulu, HI"]]

## What if we want to do the same computation for every group? For example,
## what if we want to take the mean of each group?

temps = split(w$tmax, w$station)
names(temps)
sapply(temps, mean, na.rm = T)

## The `sapply()` function is an "apply" function; it applies a function to
## every element of a vector or list. We'll see more examples later.

## It's also possible to undo a split.
##
##     unsplit(SPLIT, GROUPS)
##
## An example:

spl
unsplit(spl, dogs$breed)

## Writing Functions
## -----------------
## A function is like a factory: raw materials (inputs) go in, products
## (outputs) come out.
##
##              +-------+
##     -- in -->|   f   |-- out -->
##              +-------+
##
## You can write your own function with the `function` command. Just like any
## other object in R, you can assign functions to variables.

# Squaring function
sq = function(x) x^2
sq(2)
sq(x = 3)
sq(y = 10)
sq()

## To write a function with more than one line of code, use curly braces `{ }`.
## The last line of the function is the output. For example:

to_celsius = function(farenheit) {
  celsius = (farenheit - 32) * (5 / 9)

  celsius
}

to_celsius(76)
to_celsius(90)

## You can use `return()` to immediately output a value and end the function.
## Code after a return is ignored.

to_celsius = function(farenheit) {
  celsius = (farenheit - 32) * (5 / 9)

  return(celsius)

  "Farenheit is cooler than celsius!"
}

# This function could be written in one line.
to_celsius = function(farenheit) {
  (farenheit - 32) * (5 / 9)
}

# The function is vectorized since its internal code is vectorized.
to_celsius(c(76, 32, 90))
to_celsius(32)

## A _default argument_ is the argument a function
## uses when no argument is specified. You can set
## default arguments when you write a function.

sq()
sq = function(x = 9) x^2
sq(2)

pct_diff = function(x, ref = 10) {
  diff = x - ref
  diff / ref
}

pct_diff(3)

# The order of the arguments matters, unless you specify names.
third = function(a, b, c, d, e) {
  c
}

third(1, 2, 3, e = 4, d = 5)
third(c = -5, a = 1, b = 7, d = 10, e = 9)

## Scoping
## -------
## When you assign a variable...
##
## ...outside a function, it's a global variable.
##    A nomadic world traveller!
##
## ...inside a function, it's a local variable.
##    Lives inside the function!
##
## Most functions can only change local variables.

# This is global.
big_river = "None"

davis = function() {
  big_river = "Putah Creek"

  big_river
}

davis()
big_river

## Parameters count as local variables.

davis = function(big_river = "Putah Creek") {
  big_river
}

davis("Oh no, the Sac river levy flooded!")

## Functions will use a global variable if they can't find a local variable.

needles = function() {
  big_river
}

needles()

las_vegas = function() {
  casino
}

las_vegas()

##  Local variables don't exist outside their function.

davis = function() {
  grocery = "Nugget"

  grocery
}

davis()
grocery

## Use parameters rather globals to pass inputs in!

## How To Write Functions?
## -----------------------
## A very important skill!!!
##
## Functions are the building blocks for more sophisticated programs. Break
## steps into short functions.
##
##   1. Easier to make sure each step works correctly.
##
##   2. Easier to modify, reuse, or repurpose step.
##
## What do you want to do? Explain to yourself in a comment.
##
## Is there a built-in function?
##
## Write the function for a simple or "toy" case first.
##
## Draw a picture of the steps on paper.

function(x) mean(x) # just use mean

## Apply Functions
## ---------------
## Apply functions apply a function to each element of a vector or list.
##
##     | 3 |                | sin(3) |
##     | 2 |  -- sin() -->  | sin(2) |
##     | 4 |                | sin(4) |
##
## `lapply()` returns a list. Usage:
##
##     lapply(DATA, FUNCTION, ...)
##
## An example:

x = c(3, 2, 4)
lapply(x, sin)

## This is a lot like vectorization, but vectorization is faster. Use
## vectorization whenever possible.

sin(x)

## Apply functions are useful with `split()`.

# For each dog breed, divide speed by age, then take mean.
standardized_speed = function(x, mult = 1) {
  mean(x$speed / x$age, na.rm = T) * mult
}

spl$Poodle
standardized_speed(spl$Poodle)

lapply(spl, standardized_speed)
lapply(spl, standardized_speed, 100)

## Data frames are lists, so apply functions work.

typeof(dogs)
lapply(dogs, class)

lapply(dogs[1:2], sd, na.rm = T)

## `sapply()` tries to simplify the result.
##
##     sapply(DATA, FUNCTION, ...)
##
## An example:

lapply(dogs[1:2], sd)
sapply(dogs[1:2], sd)

## Using `split()` and then `sapply()` is a good strategy.

by_sex = split(dogs$speed, dogs$sex)
sapply(by_sex, mean)

by_station = split(w$tmax, w$station)
sapply(by_station, mean, na.rm = T)

## `tapply()` is a shortcut for `split()` and then
## `sapply()`.
##
## It splits the rows of a data frame into groups,
## according to one or more factors, and then
## applies the function to each group.
##
##     tapply(DATA, GROUPING, FUNCTION)
##
## An example:

tapply(w$tmax, w$station, mean, na.rm = T)

## `aggregate()` is an alternative to `tapply()`
## that returns a data frame.
##
##     aggregate(DATA, GROUPING, FUNCTION)
##
## An example:

aggregate(w$tmax, list(w$station), mean)

## `mapply()` works on two or more vectors
## simultaneously.
##
##     mapply(FUNCTION, ..., ARGS)
##
## An example:

foo = function(x, y) {
  (x - y) / (x + y)
}

a = c(1, 2, 3, 4)
b = c(5, 7, 9, 8)

mapply(foo, a, b)
foo(1, 5)
foo(2, 7)


## Other apply functions:
##
## * apply: apply a function to rows or columns of
##   a matrix
##
## * vapply: apply a function to each element,
##   efficiently
##
## * rapply: apply a function to each element,
##   recursively
##
## See StackOveflow post (link will be posted).
