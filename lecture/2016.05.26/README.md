# STS 98 - Lecture 2016.05.26

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Announcements
-------------
Please vote on topics for next Tuesday! (Piazza poll will go up later
today).


Lattice Customization
---------------------
Last time we made a lattice plot of vehicle post frequency by drivetrain.

What if we want to change the line colors and styles?

What if we want to add other lines?


Here's a strategy for making customized lattice plots:

```r
# 0. Compute the data frame or matrix you want to plot.
v = readRDS("cl_vehicles.rds")
drive_freq = table(as.Date(v$date_posted), v$drive)
drive_freq = as.data.frame(drive_freq)
names(drive_freq) = c("date", "drive", "freq")

# 1. Change aesthetic (color, size, etc) settings for the plot and legend.
settings = trellis.par.get()
settings$superpose.line$lty = c("solid", "dashed", "dotted")

library("RColorBrewer")
display.brewer.all()
settings$superpose.line$col =  brewer.pal(3, "Set1")

# trellis.par.set(settings)
key = list(points = FALSE, lines = TRUE)

# 2. (optional) Define a panel function.
panel = function(x, y, ...) {
  # Draw stuff!
  panel.abline(v = as.Date("2016-04-30"), lwd = "3")
  panel.xyplot(x, y, ...)
  panel.points(as.Date("2016-04-28"), 200)
}

# 3. Draw the plot!
library("lattice")
xyplot(freq ~ as.Date(date), drive_freq, groups = drive,
       type = 'l', auto.key = key, par.settings = settings,
       panel = panel)
#abline(v = as.Date("2016-04-30"))
```




To change styles: change default plot settings in one place, so that the
aesthetics are consistent.
```r
show.settings()
settings = trellis.par.get()
```

To add lines/points: write your own _panel function_.

Each box or _panel_ in a lattice plot is drawn by a panel function. Lattice
has lots of built in panel functions that you can use as building blocks to
write your own.

The syntax is:

```r
panel = function(x, y, ...) {
  # Draw stuff!
}
```

Built-in panel functions:

Function               | What does it draw?
---------------------- | ------------------
panel.3dscatter        |
panel.3dwire           |
panel.abline           | straight lines
panel.arrows           | arrows
panel.average          |
panel.axis             |
panel.barchart         | bar plot
panel.brush.splom      |
panel.bwplot           | box plot
panel.cloud            |
panel.contourplot      | contour plot
panel.curve            | mathematical functions
panel.densityplot      | density plot
panel.dotplot          | dot plot
panel.error            |
panel.fill             |
panel.grid             |
panel.histogram        | histogram
panel.identify         |
panel.identify.cloud   |
panel.identify.qqmath  |
panel.levelplot        |
panel.levelplot.raster |
panel.linejoin         |
panel.lines            | lines
panel.link.splom       |
panel.lmline           |
panel.loess            |
panel.mathdensity      |
panel.number           |
panel.pairs            |
panel.parallel         |
panel.points           | points
panel.polygon          |
panel.qq               |
panel.qqmath           |
panel.qqmathline       |
panel.rect             |
panel.refline          |
panel.rug              |
panel.segments         |
panel.smoothScatter    | smooth scatter plot
panel.spline           |
panel.splom            | scatter plot matrix
panel.stripplot        |
panel.superpose        |
panel.superpose.2      |
panel.superpose.plain  |
panel.text             | text
panel.tmd.default      |
panel.tmd.qqmath       |
panel.violin           | violin plot
panel.wireframe        | 3-d wireframe plot
panel.xyplot           | scatter plot

How to use locator with lattice:

```r
library("grid")
loc = grid.locator()

# Use the coordinates in grid drawing functions.

grid.points(loc$x, loc$y)
```

Let's plot price against odometer again.

```r
# 0. Compute data.

# 1. Change plot settings.

# 2. Define panel.
panel = function(x, y, ...) {
  panel.smoothScatter(x, y, ...)
}

# 3. Draw plot.
xyplot(price ~ odometer | drive, v, xlim = c(0, 1e6), ylim = c(0, 1e5),
       panel = panel, nbin = 200, colramp = viridis)

library("viridis")
colramp = function(n) {
  brewer.pal(n, "Set1")
}

```

ggplot2
-------
The 3 main ways to make plots in R are:

1. base R - `plot()` and friends

2. lattice

3. ggplot2

Each is incompatible with the others. For instance, base R plot commands
don't affect with lattice plots.



ggplot2's fundamental idea is that ANY graphic is composed of a few layers:

Layer | Name        | Examples
----- | ----------  | --------
data  | data        | any data frame
aes   | aesthetics  | x and y position, color, line style
geom  | geometry    | points, lines, bars, boxes
stat  | statistics  | none, bins, sums, means
scale | scales      | axes, legends
coord | coordinates | Cartesian, logarithmic, polar
facet | facets      | side-by-side panels

These layers form a descriptive "grammar of graphics".

See the documentation at <http://docs.ggplot2.org/>.

So how can we actually make a plot?

```r
#install.packages("ggplot2")
library("ggplot2")

head(diamonds)
qplot(carat, price, data = diamonds)
```

The "q" in `qplot()` stands for "quick".

Change the geometry to change the type of plot. It's possible to use
multiple geometries.

```r
qplot(price, data = diamonds, geom = "density")

qplot(carat, price, data = diamonds, geom = "point")

qplot(carat, price, data = diamonds, geom = c("point", "density_2d"))

qplot(carat, price, data = diamonds, geom = "bin2d", bins = 200)

qplot(carat, price, data = diamonds, geom = "hex", main = "Hex Plot")
```

What geometries are available?

abline, area, bar, bin2d, blank, boxplot, contour, count, crossbar, curve,
density, density2d, density_2d, dotplot, errorbar, errorbarh, freqpoly, hex,
histogram, hline, jitter, label, line, linerange, map, path, point,
pointrange, polygon, qq, quantile, raster, rect, ribbon, rug, segment,
smooth, spoke, step, text, tile, violin, vline

It's also easy to create faceted plots.

```r
qplot(price, data = diamonds, binwidth = 100, facets = clarity ~ cut)

qplot(carat, price, data = diamonds, facets = cut ~ .)

qplot(carat, price, data = diamonds, facets = . ~ cut)

qplot(color, price / carat, data = diamonds, geom = "boxplot",
  facets = . ~ clarity)
```

ggplot2 distinguishes between _mapping_ an aesthetic to a variable and
_setting_ an aesthetic to a constant value. The default is mapping.

Special syntax is needed to set an aesthetic.

```r
qplot(carat, price, data = diamonds, geom = "point", color = cut)

qplot(carat, price, data = diamonds, geom = "point", color = I("blue"),
  size = I(10))

qplot(carat, price, data = diamonds, geom = "point", size = price,
  color = cut, shape = cut)

qplot(carat, price, data = diamonds, geom = "point", size = price,
  color = cut, alpha = I(1 / 100), main = "Price vs Carat")
```

Although `qplot()` is very powerful, sometimes you want even more control to
customize the plot.

```r
gg = ggplot(diamonds, aes(x = carat, y = price, color = cut))
gg + geom_point()
gg + geom_line()
```

The `ggplot()` function just sets up the data and aesthetic layers. It's up
to you to add geometries!

Very easy to drop in a different data frame:

```r
gg = ggplot(diamonds, aes(x = carat, y = price, color = cut))
gg = gg + geom_point()

gg %+% subset(diamonds, price >= 10000)
gg %+% subset(diamonds, cut == "Fair")
gg %+% subset(diamonds, depth > 65)
```

To learn more about how to customize ggplots, read

* "ggplot2" by Hadley Wickham

* "The R Graphics Cookbook" by Winston Chang

The ggplot2 package can be used with the ggmap package to create very nice
maps.


Reproducibility
---------------
Writing clean, organized code is an essential programming skill. Sooner or
later, someone else will want or need to run your code to reproduce your
results. Try to make it easy for them!

Use descriptive variable names and comment on your code so that you and
others can understand it later.

Organize code into "paragraphs" that perform a single step of the larger
computation. Put blank lines between paragraphs. Use functions to organize
steps that might be used many times.

Avoid using absolute paths ("C:/Users/My Data/stock_data.rds"). Use a
variable to store the path so it can be changed easily, and use paths
relative to your R script ("stock_data.rds")


What Next?
----------
* STA 32 - learn intro stats
* STA 141ABC - advanced R
* ECS 10 - intro python and programming

Data studies classes!
 * Advanced R visualizations
 * Data ethnography (archaeology)
 * Data ethics


