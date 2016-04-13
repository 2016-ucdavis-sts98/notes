# STS 98 - Lecture 2016.04.12

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Visitor next week:
 [Tim McCarthy](http://timmccarthy.com/), former President of Charles Schwab
 and Fidelity Investment.

Extra office hours again:
 Th 5-7 pm, DSI Conference Room (near Shields 360).

Today's Goals
-------------

* Plot a breakdown of regular earthquakes and tsunamis for the top 10
  countries in the NOAA quakes data.

* What are some more ways to summarize the content of data?

2-dimensional Sorting
---------------------
Let's go back to the earthquakes data.

```r
q = read.delim("signif.txt")
names(q) = tolower(names(q))
```

First, how can we get a breakdown of regular earthquakes and tsunamis for
each country?

```r
tsu = table(q$country, q$flag_tsunami)
```

How can we sort the table from least to most earthquakes?

```r
sort(tsu)
```

The `sort()` function sorts everything, but we really only want to sort the
rows.

Idea: the subset operator `[` can reorganize rows using row numbers.

```r
tsu[c(1, 2, 3), ]
tsu[c(2, 3, 1), ]
```

Can we get a vector of ordered row numbers?

This is exactly what the `order()` function does!

```r
x = c(20, 21, -4, 22)
order(x)
```

The result says the 3rd element of `x` should come 1st, the 1st element of
`x` should come 2nd, and so on.

We can also use columns!

```r
order(tsu$Tsu)

head(tsu$Tsu)
```

Well...not quite. The `$` operator doesn't work for objects with class
`table`, so let's convert the table to a data frame.

```r
tsu = data.frame(Quake = tsu[, 1], Tsu = tsu[, 2])

head(tsu$Tsu)
```

Now we can use `$` to grab the column, then use `order()`.

```r
ord = order(tsu$Tsu)
tsu = tsu[ord, ]
```

There might be ties! The `order()` function can break ties:

```r
ord = order(tsu$Tsu, tsu$Quake)
tsu = tsu[ord, ]
```

But here let's sort by the total number of earthquakes, regardless of
whether it's a tsunami or not.

```r
ord = order(tsu$Tsu + tsu$Quake)
tsu = tsu[ord, ]
```

Now let's plot it. We can use `barplot()` or `dotchart()` to display count
data.

```r
top10 = tail(tsu, 10)

# With dotchart or barplot directly:
top10_mat = as.matrix(top10)
top10_mat = t(top10_mat)
# Need to transpose (rotate) the matrix:
dotchart(top10_mat)
barplot(top10_mat)
```

We can make the plot easier to read by adding labels and a legend:

```r
barplot(top10_mat, beside = T, main = "Earthquakes & Tsunami by Country",
  ylab = "Counts")
# Find legend position with locator(1).
legend(1.1, 451.6, rownames(top10_mat), fill = c("black", "white"))
```

Alternatively, for the dotchart we can put the points for regular quakes and
tsunami on the same line:

```r
# Plot the regular quakes. Need to set the limits of the x-axis so that the
# tsunami counts will show when we add them.
dotchart(top10$Quake, rownames(top10), xlim = range(top10))

# Add the tsunami counts. The first argument is the counts; the second argument
# is the y-axis line number for each count.
points(top10$Tsu, seq_along(top10$Tsu), pch = 3)

# Here the seq_along() function just creates a vector of numbers starting from
# 1 that has the same length as top10$Tsu.
seq_along(top10$Tsu)
```

There's a bunch of functions for making plots in R:

Function           | Purpose
------------------ | -------
plot()             | general plot function
barplot()          | bar plot
dotchart()         | dot chart (use instead of bar plot or pie chart)
boxplot()          | box and whisker plot
hist()             | histogram
plot(density(...)) | density plot
mosaicplot()       | mosaic plot
pairs()            | matrix of scatterplots
matplot()          | grouped scatterplot
smoothScatter()    | smooth scatterplot
stripchart()       | one-dimensional scatterplot

There's also a bunch of functions for customizing plots:

Function | Purpose
-------- | -------
lines()  | add lines to a plot
points() | add points to a plot
abline() | add straight lines to a plot
legend() | add legends to a plot
axis()   | add axes to a plot
par()    | change plot settings

Guidelines for plots:

* Choose an appropriate plot for the data you want to represent.

* Always add a title and axis labels. These should be in plain English, not
  variable names!

* Specify units after the axis label if the axis has units. For instance,
  "Height (ft)".

* Don't forget that many people are colorblind! Use point (`pch`) and line
  (`lty`) styles to distinguish groups; color is optional.

* Add a legend whenever you've used more than one point or line style.

* Always write a few sentences explaining what the plot reveals. Don't
  describe the plot, because the reader can just look at it. Instead,
  explain what they can learn from the plot and point out important details
  that are easily overlooked.

Statistics
----------

There are 3 kinds of data in the real world. These are not specific to R.

1. _Categorical_ - data separated into specific categories, with no order.
   For example, hair color (red, brown, blonde, ...) is categorical.

2. _Ordinal_ - data separated into specific categories, with an order. For
   example, school level (elementary, middle, high, college) is ordinal.

3. _Numerical_ - decimal numbers. There are no specific categories, but
   there is an order. For example, height in inches is numerical.

The `table()` function is great for summarizing categorical and ordinal
data. How can we summarize numerical data?

Two important questions to ask about data are:

1. Where is it? This is the _location_ of the data.

2. How spread out is it? This is the _scale_ of the data.

Let's use the data

```r
x = c(-2, -1, -1, -1, 0, 2, 6)
```

as an example.

Location is generally summarized with a number near the middle or center of
the data. A few options are:

1.  _Mode_ - the value that appears most frequently. The mode can be
    calculated for any kind of data, but doesn't work well for numerical
    data.

    For our example, the mode is -1. Compute this with `table()`:

    ```r
    table(x)
    ```

2.  _Median_ - sort the data, then find the value in the middle. The median
    can be calculated for ordinal or numerical data.

    For our example, the median is -1. Compute this with `median()`:

    ```r
    median(x)
    ```

3.  _Mean_ - the balancing point of the data, if a waiter was trying to
    balance the data on a tray. The mean can only be calculated for numerical
    data.

    For our example the mean is 0.4285. Compute this with `mean()`:

    ```r
    mean(x)
    ```

Adding large values to the data affects the mean more than the median:

```r
y = c(x, 100)
mean(y)
median(y)
```

Because of this, we say that the median is _robust_.

The mean is good for getting a general idea of where the center of the data
is, while comparing it with the median reveals whether there are any
unusually large or small values.

Scale is generally summarized by a number that says how far the data is from
the center (mean, median, etc...). Two options are:

1.  _Standard Deviation_ - square root of the average squared distance to the
    mean. As a rule of thumb, most of the data will be within 3 standard
    deviations of the mean.

    We can compute the standard deviation with `sd()`:

    ```r
    sd(x)
    ```

2. _Interquartile Range_ - difference between the 75th and 25th percentile.
   The median is the 50th _percentile_ of the data; it's at the middle of
   the sorted data. We can also consider other percentiles. For instance,
   the 25th percentile is the value one-quarter of the way through the
   sorted data.

   _Quantile_ is another word for percentile. _Quartile_ specifically refers
   to the 25th, 50th, and 75th percentiles.

   We can compute percentiles with `quantile()`, and use subsetting to get
   the IQR.

   ```r
   quantile(x)
   
   # IQR
   quantile(x)[4] - quantile(x)[2]
   ```

Finally, we can display all of this information visually with a box plot.
The bottom of the box is at the 25th percentile, the line in the middle is
at the 50th percentile, and the top of the box is at the 75th percentile.

The upper whisker of the plot extends to the largest data point no more than
1.5 IQRs above the box, and the lower whisker extends to the smallest data
point no more than 1.5 IQRs below the box. Points more than 1.5 IQRs from
the box are called _outliers_ and shown as empty circles.

To make a box plot in R, use the `boxplot()` function:

```r
boxplot(x)
```

NOAA Weather Data
-----------------
_This part of the notes won't be covered until April 14, but it's included
for anyone who wants a head start._

We'll use the NOAA Climate Data Online daily summaries for several cities
from around the world. This data is posted to GitHub.

```r
w = read.csv("data/noaa_daily.csv")
```

What's in the data?

```r
head(w)
levels(w$station)
```

Every day, the lowest (tmin) and highest (tmax) temperature are recorded.

What's the mean high temperature in Davis? What's the median high
temperature?

```r
davis = subset(w, station == "Davis, CA")
mean(davis$tmax)
median(davis$tmax)

sand = subset(w, station == "San Diego, CA")
mean(sand$tmax)
median(sand$tmax)
```

What does it mean when the median is higher than the mean? Or vice-versa?

How much does the temperature vary?

```r
sd(davis$tmax)
sd(sand$tmax)
```

Most temperatures will be less than 3 standard deviations above or below the
mean.

```r
mean(davis$tmax) + 3 * sd(davis$tmax)
mean(davis$tmax) - 3 * sd(davis$tmax)

range(davis$tmax)

quantile(davis$tmax)
```

Use a box and whisker plot to visualize the temperatures.

```r
boxplot(davis$tmax)
abline(h = mean(davis$tmax), lty = "dotted", col = "blue")

# Add lines for 1 sd above and below.
above = mean(davis$tmax) + 1 * sd(davis$tmax)
below = mean(davis$tmax) - 1 * sd(davis$tmax)
abline(h = c(above, below), lty = "dotted", col = "red")
```

It's more interesting if we plot all the stations.

```r
boxplot(tmax ~ station, w)
```

We can also look at temperature over time.

```r
plot(tmax ~ date, davis)
```

Performance is better if we tell R the date is a date, not a category.

```r
davis$date = as.Date(davis$date)
sand$date = as.Date(sand$date)
class(davis$date)
```

Now we can make a plot.

```r
plot(tmax ~ date, davis, type = 'l', xlab = "Date", ylab = "Max Temp (F)",
  main = "Temperatures in CA Cities")
# Add lines for San Diego.
lines(tmax ~ date, sand, type = 'l', lty = 'dashed', col = 'blue', lwd = 2)
locator(1)
legend(15824.88, 54.12, c("Davis", "San Diego"), lty = c("solid", "dashed"),
  col = c("black", "blue"))
