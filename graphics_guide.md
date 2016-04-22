
# R Graphics Guide

* Choose an appropriate plot for the data you want to represent.

* Always add a title and axis labels. These should be in plain English, not
  variable names!

* Specify units after the axis label if the axis has units. For instance,
  "Height (ft)".

* Don't forget that many people are colorblind! Also, plots are often printed
  in black and white. Use point (`pch`) and line (`lty`) styles to distinguish
  groups; color is optional.

* Add a legend whenever you've used more than one point or line style.

* Always write a few sentences explaining what the plot reveals. Don't
  describe the plot, because the reader can just look at it. Instead,
  explain what they can learn from the plot and point out important details
  that are easily overlooked.

* Sometimes points get plotted on top of each other. This is called
  _overplotting_. Plots with a lot of overplotting can be hard to read and can
  even misrepresent the data by hiding how many points are present. Use a
  smooth scatter plot or jitter the points to deal with overplotting.

* For side-by-side plots, use the same axis scales for both plots so that
  comparing them is not deceptive.

What plot is appropriate?

Variable    | Versus      | Plot
----------- | ----------- | ----
numerical   |             | box, histogram, density
categorical |             | bar, dot
categorical | categorical | mosaic, bar, dot
numerical   | categorical | box,  density
numerical   | numerical   | scatter, smooth scatter, line

If you want to add:

* 3rd numerical variable, use it to change point/line sizes.

* 3rd categorical variable, use it to change point/line styles.

* 4th categorical variable, use side-by-side plots.


## Base R Graphics

Before plotting, use `par()` to change general plot settings. Many of the
parameters for `par()` can also be used as parameters in the plotting
functions, so take a look at `?par`.

Functions for making plots:

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
curve()            | plot a function

Functions for customizing plots:

Function | Purpose
-------- | -------
lines()  | add lines to a plot
arrows() | add arrows to a plot
points() | add points to a plot
abline() | add straight lines to a plot
legend() | add legends to a plot
title()  | add title or labels to a plot
axis()   | add axes to a plot

## Lattice Graphics

Lattice has plotting functions similar to R's built-in plotting functions.

R Built-in      | Lattice
----------      | -------
plot()          | xyplot()
barplot()       | barchart()
dotchart()      | dotplot()
boxplot()       | bwplot()
hist()          | histogram()
plot(density()) | densityplot()

All of the lattice functions use formula notation:

    y ~ x | group

The "group" in the formula makes side-by-side plots, with one for each group.
Sometimes side-by-side plots are called _faceted_ plots.

The lattice functions also a have a separate groups parameter for marking
groups within a single plot.

Setting the `auto.key` parameter to `TRUE` tells lattice to add a legend.

It's possible to use both groupings at once.

The drawback of lattice is that LATTICE DOES NOT WORK WITH THE BUILT-IN
PLOTTING FUNCTIONS!!!
