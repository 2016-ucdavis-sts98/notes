
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

