## # STS 98 - Lecture 2016.05.12
##
## See [notes.R](notes.R) to follow along in RStudio.
##
## Once again, I forgot to save the R session.
##
## However, here's some additional [notes on mapping](maps.R).

## Announcements
## -------------
## (5/17) Guest Speakers: Triage Consulting
##
## CL Apartments data is now available as separate CSV files (by region).


## Questions
## ---------


## Shapefiles
## ----------
## The maps in the maps package are not very detailed, especially outside the
## US. What if you want to use other maps?
##
## Get more maps online!
##
##
##
## A _shapefile_ (extension `.shp`) is a format for map data. Other formats are
## also used, but shapefiles are the most popular.
##
## Most shapefiles are actually a collection of files that include shapes on
## the map and additional information.
##
## The rgdal package has functions for loading shapefiles into R. However, to
## use rgdal you must install the Geospatial Data Abstraction Library (GDAL).
##
##
##
## I've converted the US Census shapefiles into RDS files for you.
##
## R represents map data with the class `SpatialPolygonsDataFrame`.

county = readRDS("data/maps/shp_county.rds")

class(county)

## Use the `names()` function to see if any additional information is included.

names(county)
head(county$NAME)

## Map data can be displayed directly with the `plot()` function.

plot(county)

place = readRDS("data/maps/shp_place.rds")
plot(place)

## Region names are listed in the NAME column.
##
## Take a subset to restrict to a specific region!

sfbay = c("San Francisco", "Alameda")
sf_county = subset(county, NAME %in% sfbay)
plot(sf_county)

sf_place = subset(place, county %in% sfbay)
plot(sf_county)
plot(sf_place, add = T)

# Change border colors with plot.
plot(sf_county, border = "red")
plot(sf_place, add = T)

# Alternative: change border colors with map.
library("maps")
map(sf_county, col = "red")
plot(sf_place, add = T)

## You can also use other maps functions with the shapefiles:

map.scale(metric = F)

## Data Cleaning - Outliers
## ------------------------
## How can we tell if price and odometer are related?

v = readRDS("cl_vehicles.rds")
plot(price ~ odometer, v)

summary(v$price)

# Turn off scientific notation.
options(scipen = 999)
summary(v$price)

boxplot(v$price)

## An _outlier_ is a point that's far away from most of the other data.
##
## In fact, outliers are suspicious because of this. They could be due to
## errors when the data was measured or recorded.
##
##
##
## There's no specific definition for "far away"!
##
## Sometimes people label outliers as any points:
##
## * more than 1.5 IQRs below 25th or above 75th quantile
##
## * more than 3 standard deviations above or below the mean
##
## You can use the `scale()` function to compute how many standard deviations a
## point is from the mean.

head(scale(v$price))

## BE CAREFUL!!!
##
## These definitions don't work in every situation. Always make a plot to see
## what's going on first.

boxplot(v$price)

## How can you handle outliers?
##
## First, try to use other covariates to determine whether the outliers are
## valid data or errors.

index = which.max(v$price)
index
v[index, ]

## When an outlier is valid, keep it.
##
## You can adjust the x and y limits on plots as needed to "ignore" the
## outlier, but make sure to mention it in any analysis you do.
##
##
##
## When an outlier is not valid, first try to correct it.
##
## Try to:
##
## * Correct with a different covariate from the __same observation__.
##
## * Estimate with a location statistic (mean, median) based on "similar"
##   observations. This is called _imputation_.
##
## For the vehicles data, we can use the `text` covariate.

v[index, "price"] = 32000

## If other covariates don't help with correction, try external sources.
##
## If you can't correct the outlier but know it's invalid, replace it with a
## missing value (NA).

indexes = order(v$price, decreasing = T)
v[indexes[1], ]
v[indexes[2], ]
v[indexes[3], ]

plot(density(v$price, na.rm = T))

## Before we go back to the original question, let's take a detour...


## Data Cleaning - Missing Values
## ------------------------------
## Examining outliers and missing values are both data cleaning steps.
##
## R represents missing values as NA.

NA

is.na(NA)
is.na(5)

table(is.na(v$price), v$fuel)

# Two packages for missing values: mice, VIM

## Missing values can be:
##
## * missing not at random (MNAR) - causes bias!
##
## * missing at random (MAR)
##
## When values are missing not at random, the cause for missingness depends on
## other covariates. These covariates may or may not be in the data set. Think
## of this as a form of censorship.
##
## For example, if people in a food survey refuse to report how much sugar they
## ate on days where they ate junk food, data is missing not at random.
##
## When values are missing at random, the cause for missingness is not related
## to any of the other covariates. This is rare in practice.
##
## For example, if people in a food survey accidentally overlook some
## questions.
##
##
##
## Values MNAR can bias your analysis! Just like error values, missing values
## can sometimes be corrected or imputed:
##
## * Correct whenever possible, for values MNAR or MAR.
##
## * Impute values MNAR. Imputed values can also bias your analysis, so it's
##   often better not to impute values MAR.
##
##
##
## If you need to remove a missing value, subset with `!is.na()`.

v_no_na_price = subset(v, !is.na(price))
nrow(v_no_na_price)

## Using `na.omit()` is less precise because it removes rows that have a
## missing value in ANY column. Lots of information gets lost!!!

v_no_na = na.omit(v)
nrow(v_no_na)

boxplot(v$odometer)
summary(v)

na_detector = function(col) {table(is.na(col))}
sapply(v, na_detector)

## Statistics - Correlation
## ------------------------
## Back to the question: how can we tell if price and odometer are related?

plot(price ~ odometer, v)

smoothScatter(v$odometer, v$price, 1000, xlim = c(0, 5e5), ylim = c(0, 1e5),
  asp = 1)

## Set `asp = 1` to make sure 1 unit on the x-axis corresponds to 1 unit on the
## y-axis.
##
## Think about what the appropriate aspect ratio is for your particular data.
##
## __Q__: How can I fit a line?
##
## __A__: Use the `lm()` function. The name stands for "linear model".

line = lm(price ~ odometer, v)
# Add the line to the plot. a is intercept, b is slope.
coef(line)
abline(a = coef(line)[1], b = coef(line)[2], col = "red", lwd = 3)
