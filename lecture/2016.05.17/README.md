# STS 98 - Lecture 2016.05.17

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Announcements
-------------
Assignment 4 deadline extended to 5/22 at 11:55pm.

Hand in paper copies on Monday/Tuesday.


Questions
---------
__Q__: How can I save data I've cleaned?

__A__: Use `saveRDS()` to save any variable as an RDS file.

```r
x = anscombe
saveRDS(x, "my_data.rds")
```

If you want to load a data frame in Excel or another non-R program, save the
data as a CSV file instead:
```r
write.csv(x, "my_data.csv")

```

Statistics - Correlation
------------------------
Last time: how can we tell if price and odometer are related?
```r
v = readRDS("cl_vehicles.rds")
plot(price ~ odometer, v)
```

How can we tell for any two covariates?

Can we come up with a statistic?

```r
df = readRDS("data/random_points.rds")
plot(y1 ~ x, df)
abline(v = mean(df$x), lty = 'dotted', col = 'red')
abline(h = mean(df$y1), lty = 'dotted', col = 'red')

plot(y2 ~ x, df)
abline(v = mean(df$x), lty = 'dotted', col = 'red')
abline(h = mean(df$y2), lty = 'dotted', col = 'red')
```

_Correlation_ is a statistic that measures how well the covariates make a
line when plotted as (x, y) points. This is called a _linear_ relationship.

Correlation ranges from -1 to 1:

* Zero means the points don't make a line.

* Negative correlation means a line with negative slope.

* Positive correlation means a line with positive slope.

Calculate correlation with the `cor()` function.

```r
cor(df$x, df$y1)
cor(df$x, df$y2)
```

BE CAREFUL!!!

Correlation only measures linear relationships. Correlation 0 doesn't mean
there's no relationship.

Correlation doesn't imply causation. Correlation is just a statistic.


Anscombe's Quartet
------------------
_Anscombe's Quartet_ is a collection of four data sets.

Each data set has a vector of x coordinates and a vector of y coordinates.

```r
head(anscombe)
```

How much information is "enough" to characterize data?

Mean and standard deviation?

```r
colMeans(anscombe)
sapply(anscombe, sd)
```

Median and IQR?

```r
sapply(anscombe, median)
sapply(anscombe, IQR)
```

Correlation?

```r
mapply(cor, anscombe[1:4], anscombe[5:8])
```

Let's try plotting it.

```r
par(mfrow = c(2, 2))
mapply(plot, anscombe[1:4], anscombe[5:8])
```

Each data set in Anscombe's Quartet is very different from the others, but
it's hard to see unless we plot them!

Always inspect your data graphically!
