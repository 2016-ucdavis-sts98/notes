# STS 98 - Lecture 2016.04.14

See [notes.R](notes.R) to follow along in RStudio.

I accidentally forgot to save the R input from this lecture. Sorry guys! If
there are any questions, ask on Piazza or in OH. Most of the commands are
also listed in these notes.

Visitor next week:
 [Tim McCarthy](http://timmccarthy.com/), former President of Charles Schwab
 and Fidelity Investment.

Extra office hours TODAY:
 Th 5-7 pm, DSI Conference Room (near Shields 360).

Assignment 2 deadline extended to April 17th.

Questions
---------

__Q__: How to plot error bars?

__A__: Add them to the plot with the `arrows()` function. The `barplot()`
function gives the x-coordinates of the bars as output.

```r
x = c(4, 7.3, 2, 8.7, 5)
x_coords = barplot(x, ylim = c(0, 10))
arrows(x_coords, x + 0.5, x_coords, x - 0.5, code = 3, angle = 90)
```

__Q__: How to sort a table?

__A__: Use `order()`.

```r
q = read.delim("signif.txt")
q$INJURIES
q = q[c("YEAR","INJURIES", "COUNTRY")]

q[c(2, 3, 1), ]
ord = order(q$INJURIES)
head(q[ord, ])
# na.omit() removes NAs
tail(na.omit(q[ord, ]))
```

Today's Goals
-------------

* More examples of statistics and box plots.

* What does it mean to be "random"?

* How to break down data by groups.

NOAA Weather Data
-----------------
We'll use the NOAA Climate Data Online daily summaries for several cities
from around the world. This data is posted to GitHub.

```r
w = read.csv("data/noaa_daily.csv")
```

What's in the data?

```r
head(w)
dim(w)
str(w)
levels(w$station)
table(w$station)
```

Every day, the lowest (tmin) and highest (tmax) temperature are recorded.

What's the mean high temperature in Davis? What's the median high
temperature?

```r
mean(w$tmax, na.rm = T)
median(w$tmax, na.rm = T)

davis = subset(w, station == "Davis, CA")
mean(davis$tmax)
median(davis$tmax)

sand = subset(w, station == "San Diego, CA")
mean(sand$tmax)
median(sand$tmax)
```

What does it mean when the mean is larger than the median? Or smaller?

How much does the temperature vary?

```r
sd(davis$tmax)
sd(sand$tmax)

quantile(davis$tmax)
quantile(sand$tmax)

iqr_davis = quantile(davis$tmax)[4] - quantile(davis$tmax)[2]
iqr_davis
iqr_sand = quantile(sand$tmax)[4] - quantile(sand$tmax)[2]
iqr_sand
```

The standard deviation and interquartile range are both measures of scale
(how spread out the data is) but not completely equivalent. The IQR is
anywhere from 1.3 * SD to 2.5 * SD, so it doesn't make sense to compare SD
and IQR to each other.

Most values will be within 3 standard deviations of the mean.

```r
mean(davis$tmax) + c(-3, 3) * sd(davis$tmax)
range(davis$tmax)

mean(sand$tmax) + c(-3, 3) * sd(sand$tmax)
range(sand$tmax)
```

...or 1.5 IQRs below the 25th or above the 75th percentile. Values outside
this range are called _outliers_.

```r
quantile(davis$tmax)[c(2, 4)] + c(-1.5, 1.5) * iqr_davis
range(davis$tmax)
```

Let's use a box and whisker plot to visualize the temperatures.

```r
boxplot(davis$tmax)
```

The `abline()` function adds lines to plots. Use the `v` parameter to add
vertical lines, or the `h` parameter to add horizontal lines.

```r
# Add lines for Davis mean and 3 SD from mean.
abline(h = mean(davis$tmax), lty = "dotted", col = "red")

r = mean(davis$tmax) + c(-3, 3) * sd(davis$tmax)
abline(h = r, lty = "dotted", col = "red")

# Add a vertical line for fun.
abline(v = 1.5, col = "blue")

# Add lines for Davis 1.5 * IQR from box.
iqr_r = quantile(davis$tmax)[c(2, 4)] + c(-1.5, 1.5) * iqr
abline(h = iqr_r, lty = "dotdash", col = "plum")
```

It's more interesting if we plot all the stations.

The `boxplot()` function can automatically group data. Set the first
argument to `y ~ grp`, where `y` is the numerical data and `grp` is the
groups (categorical).

```r
boxplot(tmax ~ station, w)
```

VERY IMPORTANT: when you plot data, make sure the (x, y) or (y, grp) vectors
correspond element-by-element. It usually doesn't make sense to plot two
vectors of different lengths against each other!

DON'T DO THIS:

```r
boxplot(tmax ~ c("Honolulu, HI", "Davis, CA"), w)
boxplot(davis$tmax ~ w$station, w)

honolulu = subset(w, station == "Honolulu, HI")
# Honolulu and San Diego don't match up. We can't even be sure the dates match.
plot(honolulu$tmax, sand$tmin)
```

There are other ways to show how data is spread out. For categorical data,
we used tables, bar, and dot plots.

We could just convert numerical data to categories! This is called
_binning_. Bin data with:

    cut(x, breaks, labels, right)

Parameter | Description
--------- | -----------
x         | a vector of data to bin
breaks    | the number of bins, or a vector of break points
labels    | a vector of labels, one for each bin
right     | whether bins include right (TRUE) or left (FALSE) break point

Let's try it out:

```r
temps = davis$tmax
temps =
  cut(temps, c(-Inf, 32, 68, 80, Inf), c("Frozen", "Cold", "Nice", "Hot"))
barplot(table(temps))
```

Binning is good because it makes the data simpler, but bad because it throws
out potentially useful details. Also, the how the breaks are chosen is a
little arbitrary.

We could make a bar or dot plot of the binned data to get an idea of how
many points are in each bin. A plot of binned numerical data is called a
_histogram_. R can do the binning automatically.

```r
hist(davis$tmax, main = "Davis Max Temperature Histogram",
  xlab = "Temperature (F)")
```

Unlike a bar plot, the bars in a histogram are placed right next to each
other to show that the data is numerical, not categorical.

Histograms can also show proportions instead of counts. When showing
proportions, the histogram is rescaled so that adding up the area of all the
bars gives 1.

```r
hist(davis$tmax, freq = FALSE)
```

If we make the bins narrower, the top of the plot starts to look smoother,
but eventually each bin only has a few points in it.

What would happen if we had more data? We could keep making the bins
narrower until we got a smooth line. That line is called the _density_ of
the data. R can compute it:

```r
hist(davis$tmax, freq = F, breaks = 40)
lines(density(davis$tmax))
```

It's also possible to plot the density on its own:

```r
plot(density(davis$tmax))
```

The _distribution_ of data refers to how the data is spread out. This
includes the location and scale, but also other details. The distribution
tells us how common specific values are in the data.

Box plots, histograms, and density plots show the distribution of numerical
data.

Another way to think about the distribution of numerical data is as the
chances of seeing a certain value. Densities and histograms use the area
underneath the curve or bars to represent this.

What does it mean to be random? Random does not mean:

* Equal chance (this is _uniform_)

* Unlikely events (this is high _variability_)

Random means we're not 100% sure about what the outcome is. So the number of
sides to a typical coin is not random; there are 2 sides. On the other hand,
the number of times you'll get a heads in 10 coin flips is random, even if
the coin is biased.

What plot should you use?

Detail       | Data Type   | Plot
------       | ---------   | ----
distribution | categorical | bar / dot
             | numerical   | box / histogram / density
relationship | categorical | bar / dot / mosaic
             | numerical   | scatter / smooth scatter / line
