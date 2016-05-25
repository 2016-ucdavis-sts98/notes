## # STS 98 - Lecture 2016.05.24
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Announcements
## -------------
## Assignment 5 now posted!
##
## There will not be a second peer review.

## Git Collaboration
## -----------------
## Here are a few tips for using git as part of a team.
##
## 1.  Always pull before you push:
##
##         git pull --rebase
##         git push origin master
##
##     This guarantees you get changes your teammates have pushed to GitHub
##     before you push your own changes. Git will warn you if there are any
##     problems merging their changes with yours.
##
##     The `--rebase` parameter to the pull command tells git to apply their
##     changes to the repository before yours. This helps to avoid messy merge
##     commits.
##
## 2.  Work on different files. Most of the time, git is smart enough to
##     automatically merge changes you make, even if someone else on your team
##     changed the same file.
##
##     However, since we haven't gone over how to handle cases where git can't
##     automatically merge changes, you're better off working with separate
##     files (all in the same repository).
##
## 3.  Check out the [Git documentation](https://git-scm.com/documentation) for
##     tips on using git.


## Reshaping Data
## --------------
## We left off discussing how to rearrange tabular data sets with the reshape2
## package.

library("reshape2")

## Reshape2 divides variables in a data set into:
##
## 1. _Identifier variables_ identify the subject being measured.
##
## 2. _Measurement variables_ represent measurements on the subject.
##
## The `melt()` function melts a data set so that each row represents one
## measurement.

melt(smiths)

dogs = readRDS("data/dogs.rds")
melt(dogs)

## Missing values can be dropped by setting `na.rm = TRUE`.

melth(smiths, na.rm = TRUE)

# Identifier variables are detected automatically, but `melt()` doesn't always
# get these right.
#
# To specify identifiers, use the `id.vars` parameter. Alternatively, to
# specify measurements, use the `measure.vars` parameter.

melt(dogs, id.vars = "name")

## If some of the measurement variables are factors, R will warn that
## "attributes are not identical". You can safely ignore this warning.
##
## When is it useful to melt data?
##


# 1. When variable names should actually be variables.

melt(dogs, measure.vars = c("rabies", "distemper"))

melt(dogs, measure.vars = c("rabies", "distemper"), variable.name = "vaccine",
  value.name = "date")

# 2. To _cast_ or aggregate the data into a new shape.

m = melt(dogs, id = "name")

dcast(m, name ~ variable)
dcast(m, ... ~ variable)

## The `dcast()` function casts molten data sets. The second argument is a
## formula with the form:
##
##    IDENTIFIERS ~ variable
##
## The IDENTIFIERS determine what each row in the reshaped data represents. To
## specify all identifiers, use `...`.
##
## Casting is most useful for computing grouped statistics. In this case, the
## grouping variables should be treated as identifiers when you melt the data.

m = melt(dogs, measure.vars = c("age", "speed"))

dcast(m, breed ~ variable, mean)

dcast(m, breed + sex ~ variable, mean, na.rm = T)


## String Operations
## -----------------
## What if we want to find a specific kind of car in the vehicles data?
##
## Use the function
##
##     grep(PATTERN, TEXT, fixed = TRUE)
##
## to find the indexes of records that match.

v = readRDS("cl_vehicles.rds")
table(v$model)

grep("porsche 911", v$text, fixed = TRUE)

## The `ignore.case` parameter can be used to make the search case insensitive,
## but does not work with `fixed = TRUE`.

indexes = grep("porsche 911", v$text, ignore.case = TRUE)
indexes
v[142, ]
v[indexes, ]

## If you want to take a subset, use the `grepl()` function instead. The syntax
## is the same, but logical values are returned. TRUE means the pattern
## matched.

porsche = grepl("porsche 911", v$text, ignore.case = TRUE)
head(porsche)
nrow(v)
subset(v, porsche)

## What if we want to replace part of a string?
##
## Use
##
##     gsub(PATTERN, REPLACEMENT, TEXT, fixed = TRUE)
##
## to replace all instances of a pattern. The "g" stands for "global".
## These functions search for an exact match, so you might need to try several
## different patterns to find everything.
##

gsub("_", " ", "Hello_world!", fixed = TRUE)

## These functions also support matching with a more powerful search language
## called _regular expressions_.
##
## Regular expressions are extremely useful and are covered in more advanced
## data studies classes (also STA 141).


## Lattice Customization
## ---------------------
## How can we customize a lattice plot?

names(v)
class(v$date_posted)
drive_freq = table(as.Date(v$date_posted), v$drive)
drive_freq = as.data.frame(drive_freq)
names(drive_freq) = c("date", "drive", "freq")
head(drive_freq)

library("lattice")
class(drive_freq$date)
xyplot(freq ~ as.Date(date), drive_freq, groups = drive,
       type = "b", auto.key = TRUE)

## What if we want to customize the legend?

key = list(space = "right", points = FALSE, lines = TRUE)

xyplot(freq ~ as.Date(date), drive_freq, groups = drive, type = "b",
  auto.key = key)

## See `?simpleKey` for a list of parameters that can be used in the key.

?simpleKey

##
## What if we want to change the line colors and styles?

xyplot(freq ~ as.Date(date), drive_freq, groups = drive, type = "b",
  auto.key = key, col = 1:3)

## The legend colors are not updated.
##
## To change legend settings in lattice, we need to change the default lattice
## settings. We can see these visually:

show.settings()
settings = trellis.par.get()
str(settings)

## Get a copy of the settings to change and then change them.

settings = trellis.par.get()
settings$superpose.line$col = 1:3

xyplot(freq ~ as.Date(date), drive_freq, groups = drive,
       type = "b", auto.key = key, par.settings = settings)
