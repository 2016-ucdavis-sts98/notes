## # STS 98 - Lecture 2016.05.19
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Announcements
## -------------
## Assignment 4 due 11:55pm on Sunday 5/22.
##
## A shapefile for the neighborhoods of San Francisco is now posted.

sf = readRDS("data/maps/shp_sf_neighborhood.rds")

plot(sf)


## Questions
## ---------


## Confounding Variables
## ---------------------
## Is there a connection between the age of couples and whether they break up?
##
## In other words, is breakup explained by age?
##
## It's not meaningful to ask if age is explained by breakup, since aging is
## inevitable.
##
## We could look directly at how many people broke up for each age:

x = readRDS("hcmst.rds")
# Get rid of couples with no breakup status.
x = subset(x, !is.na(breakup))
# Compute average age.
x$avg_age = with(x, age + partner_age) / 2
summary(x$avg_age)

age_by_bkp = split(x$avg_age, x$breakup)
names(age_by_bkp)
sapply(age_by_bkp, mean, na.rm = T)

h = hist(age_by_bkp$yes, col = "gray")

## DANGER: there are two problems with this histogram
##
## 1. What if most of the couples with average age near 45 didn't break up?
##
## 2. What if most of the couples have average age near 45, regardless of
##    breakup?
##
## The histogram shows counts and ignores the couples that didn't break up!
##
##
## Instead, show the proportion of couples that broke up within each age group.

tab = table(cut(x$avg_age, h$breaks), x$breakup)
ptab_all = prop.table(tab)
ptab_rows = prop.table(tab, 1)
labels = rownames(tab)

par(mfrow = c(3, 1))
barplot(h$counts, space = 0, names.arg = labels)
barplot(ptab_all[, 1], space = 0)
barplot(ptab_rows[, 1], space = 0)

## Ignoring the total number of couples in each age group led us to an
## incorrect conclusion.
##
## The number of couples in each age group is a _confounding_ variable.
##
## In other words, a confounding variable is a variable that can lead to
## incorrect conclusions when not accounted for properly.


## Simpson's Paradox
## -----------------
## Simpson's paradox is an extreme example of how tricky confounding variables
## can be.
##
## Visualization: <http://vudlab.com/simpsons/>


## Joining Data
## ------------
## Let's say we want to design a tabular data set about musicians. We could
## use 1 row for each artist's personal information (name, age, etc).
##
## What if we also want to store album information (title, year, sales, etc)?
##
## This is a _one-to-many_ relationship.
##
## We could use 1 row for each album, but then there will be a lot of redundant
## artist information. This makes the data set's size (in bytes) larger than
## it needs to be.
##
## A SOLUTION: save the data set as two tables. One table holds artist info and
## the other table holds album info. Link the two with the artist's name.
##
##
##
## This is common in practice. Useful for distributing files, but a nuisance
## for doing data analysis.
##
## Putting separate tables back together is called _joining_ them. The variable
## used to link the tables is called the _key_.
##
## Join tables in R with the `merge()` function.

s = readRDS("data/inventory/suppliers.rds")
p = readRDS("data/inventory/parts.rds")
sp = readRDS("data/inventory/supplier_parts.rds")

## How many parts does Smith have? Or Jones?

merge(s, sp, by = "SupplierID")

##
## Use the `by` parameter to specify the key column. If the name of the key is
## different for the two tables, use `by.x` and by.y`.

s
sp
names(sp)[2] = "ID_Supplier"
head(s)
head(sp)

merge(s, sp, by.x = "SupplierID", by.y = "ID_Supplier")

## Use the `all` parameter to force all rows from both tables to show up.

merge(s, sp, by = "SupplierID", all = TRUE)

merged = merge(s, sp, by = "SupplierID")
final_merge = merge(merged, p, by = "PartID")

names(final_merge)[5] = "SupplierCity"
names(final_merge)[10] = "PartCity"
head(final_merge)

final_merge[c("SupplierName", "PartName", "Qty")]


## Reshaping Data
## --------------
## The reshape2 package makes it easy to rearrange tabular data sets.

# install.packages("reshape2")
library("reshape2")

## Reshape2 divides variables in a data set into:
##
## 1. _Identifier variables_ identify the subject being measured.
##
##    Typically a discrete variable. Examples: id number, name, time.
##
## 2. _Measurement variables_ represent measurements on the subject.
##
##    Examples: age, height, hair color.
##
## This is a little bit arbitrary: it depends on what you want to do.
##
##
##
## It's possible to rearrange the data set so that each row represents one
## measurement. This is called _melting_ the data set.
##
## The `melt()` function melts data sets.

smiths
melt(smiths)

dogs = readRDS("data/dogs.rds")
melt(dogs)

melt(dogs, measure.vars = c("rabies", "distemper"))
