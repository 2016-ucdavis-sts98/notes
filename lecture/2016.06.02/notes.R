## # STS 98 - Lecture 2016.06.02
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Also see the [R input](r_session.txt) from the lecture.

## Announcements
## -------------
## Extra OH: Today 5-7pm, Shields 360
##
## Final Exam: Monday (June 6), 10:30am - 12:30pm, Wellman 26
##
## Bring a blue book!


## Questions
## ---------


## Review
## ------
## Absence of a topic doesn't mean it won't be on the exam!
##
## Don't worry about memorizing every function in R.


## ### Density Plots
##
## A density plot is a smoothed histogram, rescaled so that the total area
## under the curve is 1.
##
## The area under the curve for any interval on the x-axis estimates the
## proportion of points that fall in that interval.
##
## For intuition, imagine simultaneously increasing the number of observations
## and decreasing the width of the bins until the tops of the histogram bars
## become a smooth curve.

df = readRDS("data/random_points.rds")

hist(df$x, freq = F, col = "gray", breaks = 30)
lines(density(df$x))

## Density plots don't work well when:
##
## * The variable shown is not continuous. If the variable takes specific,
##   discrete values, you should use a histogram instead.
##
## * There aren't many observations. Look at both the histogram and the density
##   plot to decide; the histogram may have information that gets smoothed away
##   on the density plot.


## ### Outliers
##
## An _outlier_ is an observation that doesn't fit the pattern made by the
## other observations. In other words, it's an unusual observation.
##
## An extreme value is the most common kind of outlier. This is an observation
## that's very far way from most of the other observations.
##
## There's no specific definition for "far away". In practice, it's common to
## label outliers as points...
##
## * more than 1.5 IQRs below 25th or above 75th quantile
##
## * more than 3 standard deviations above or below the mean
##
## However, these are not foolproof and you should always examine the
## observations graphically to determine which are outliers.
##
##
##
## When you find an outlier, try to explain the cause! Examining other
## variables for the outlying observation often helps. This may lead you to an
## interesting insight about the data.
##
## However, you should also consider the possibility that the outlier was
## caused by a mistake when the data was recorded. If the outlier is not a
## valid observation, try to correct it using...
##
## * information from other variables (for the same observation)
##
## * a location estimate based on "similar" observations
##
## The second strategy is called _imputation_. Imputing a value for the outlier
## is not always a good choice, because it can bias your analysis.
##
## If you know an outlier is invalid but cannot correct it, replace the value
## with a missing value.

q = read.delim("signif.txt")

boxplot(q$TOTAL_DEATHS)

library("ggmap")

map = qmap("Shanghai, CN", zoom = 4)
pts = geom_point(aes(LONGITUDE, LATITUDE, size = TOTAL_DEATHS,
    color = EQ_PRIMARY), q, alpha = 0.75)

library("viridis")
map + pts + scale_color_gradientn(colors = rev(magma(5)))

# Locate extreme values.
head(q[order(q$TOTAL_DEATHS, decreasing = T), ])


## ### Missing Values
##
## R represents missing values as NA.
##
## Missing values can be:
##
## * missing not at random (MNAR)
##
## * missing at random (MAR)
##
## When values are MNAR, they're missing for a reason! Try to come up with an
## explanation for why they're missing, as this may give you additional insight
## into the data set.
##
## Ignoring values that are MNAR can bias your analysis. There's a reason the
## points are missing! You should correct these values if possible, using the
## same strategies you would use to correct outliers.
##
## When values are MAR, they are not likely to bias your analysis, so
## correction is less important and can even be detrimental.
##
##
##
## Identifying whether values are MNAR or MAR can be difficult.
##
## The strategy is to look for relationships between the missing values and
## other variables. If you see a relationship, the values are MNAR.
##
## However, it's possible values are MNAR but the relationship is with an
## external variable that wasn't included in the data set.

q_na = subset(q, is.na(TOTAL_DEATHS))

library("lattice")
densityplot(~ YEAR, q_na)

range(q$TOTAL_DEATHS, na.rm = T)


## ### Correlation
##
## _Correlation_ measures how well two variables make a line when plotted as
## (x, y) coordinates. In other words, correlation measures linear
## relationships.
##
## Correlation ranges from -1 to 1, with -1 meaning an inverse (negative slope)
## relationship and 1 meaning a direct (positive slope) relationship. 0 means
## no __linear__ relationship was detected.
##
## For intuition, imagine slicing a scatter plot vertically at the mean of the
## x-variable and horizontally at the mean of the y-variable. This divides the
## plot into 4 pieces. If most of the points are in...
##
## * the bottom left and top right pieces, the correlation will be close to 1
##
## * the top left and bottom right pieces, the correlation will be close to -1
##
## * every piece evenly, the correlation will be close to 0
##
## The actual correlation statistic also takes into account how far the points
## are from the means. Points farther away have a stronger effect.
##
##
##
## Beware of two easy mistakes with correlation:
##
## * Correlation DOES NOT imply causation, it's just a number computed with a
##   formula. Statistics can detect patterns but cannot determine cause/effect
##   relationships.
##
## * A correlation of 0 DOES NOT imply no relationship. Correlation only
##   detects linear relationships. There could be a very strong non-linear
##   relationship, and you'd never know unless you plotted the data.
##
## How else can you detect relationships between variables?
##
## First       | Second      | Plot
## ----------- | ----------- | ----
## categorical | categorical | mosaic
## categorical | numeric     | box, density
## numeric     | numeric     | scatter

pairs(df)


## ### Confounding Variables
##
## Be careful to consider how each variable might affect your analysis.
##
## If you are examining some variables and grouping or rescaling by another
## variable changes your conclusions about the data, that variable is a
## _confounding variable_.
##
## Sometimes the relationship between variables is confounded by a variable
## that isn't even included in the data set. There's no easy way to detect
## this, so you should think hard about any conclusions you make and try to
## come up with ways they might be wrong.
##
## In other words, it's a good idea to have an attitude of _statistical
## skepticism_ when doing data analyses.
##
##
##
## The most dramatic example of confounding is called Simpson's paradox. In
## a Simpson's paradox, accounting for the confounding variable reverses the
## conclusion.
##
## See <http://vudlab.com/simpsons/> for an interactive example.


## ### Joins
##
## Data split across multiple tables is called _relational data_. A variable
## that appears in more than one table is called a _key_, and can be used to
## relate the tables.
##
## For example, a grocery chain's inventory is relational data. They might have
## a table that lists stores and another that lists food items. The key might
## be the store ID number; this connects stores to their particular food items.
##
## Relational formats are especially useful when the unit (subject) observed in
## each table is different.
##
## However, for some analyses you might want to combine two or more tables. You
## can do this by _joining_ the tables using the key(s).
##
## In some cases there may be multiple keys. Think carefully about what the
## observations are in each table you're joining!
##

parts = readRDS("data/inventory/parts.rds")
suplr = readRDS("data/inventory/suppliers.rds")
sp = readRDS("data/inventory/supplier_parts.rds")

x = merge(parts, sp, by = "PartID")
merge(x, suplr, by = "SupplierID")


## ### Tidying
##
## Variables can be divided into two groups:
##
## 1. _Identifier variables_ identify a unit of observation.
##
## 2. _Measurement variables_ are actual measurements on the unit.
##
## These definitions depend on what you want to do. However, identifier
## variables usually contain groups you'd like to compare.
##
##
##
## _Melting_ a data set puts all of the measurement variables in a single
## column and creates a new identifier variable to identify what's being
## measured.
##
## _Casting_ a molten data set puts each measurement variable in a separate
## column.
##
## Melting and casting are useful in two situations:
##
## 1. The data set doesn't have rows corresponding to observations and columns
##    corresponding to variables. By melting and casting, you can rearrange the
##    data set to satisfy this requirement.
##
## 2. You want to create a new unit of observation by aggregating the existing
##    observations.
##

library("reshape2")

melt(smiths, id.vars = c("subject", "time"))

