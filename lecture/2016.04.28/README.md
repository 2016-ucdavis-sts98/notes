# STS 98 - Lecture 2016.04.28

See [notes.R](notes.R) to follow along in RStudio.

Also see the [R input](r_session.txt) from the lecture.

Questions
---------

Review
------
Bring a blue book!

Absence of a topic doesn't mean it won't be on the exam!

However, don't worry about memorizing every function in R. The important R
functions you should know are described here.


### Git

Git is a distributed version-control system. It helps with keeping track of
different drafts of files and with distributing those drafts to other
people.

On your computer, files are organized into _directories_, which act like
file folders. A directory that's managed by git is called a _repository_.

A repository on your computer is called a _local_ repository. A repository
on any other computer is a _remote_ repository.

If want your very own copy of a remote repository, _clone_ the repository.
To keep your local repo up-to-date, _pull_ updates from the remote
repository.

If you make changes to a local repository, _add_ them so that git knows
they're important and then _commit_ them so that git saves a snapshot. If
you want to share the changes, you can _push_ them to a remote repository.

    +----------+                     +-------+
    |  remote  | --- clone/pull ---> |       |    To save your work:
    |          |                     | local |      1. Add changes.
    | (GitHub) | <----- push ------- |       |      2. Commit.
    +----------+                     +-------+



### Programming Languages

R is an interactive programming language. There are a few ideas common to
almost all programming languages.

A _variable_ is a label for a piece of data, to make it easy to reference
later.

```r
x = 5
```

A _function_ is like a factory: raw materials (inputs) go in, products
(outputs) come out.

             +-------+
    -- in -->|  foo  |-- out -->
             +-------+

The inputs to a function are called _parameters_. Values supplied as
parameters are called _arguments_.

The output of a function is sometimes called the _return value_.

The syntax to call a function is the function's name followed by
parentheses. Arguments can be specified with a comma-separated list inside
the parentheses. For example:

    foo(x = 3, y = 7, z = 2)
    |   |   |
    |   |   +----------- first argument
    |   +--------------- first parameter
    +------------------- function name


```r
sum(4, 5)
5 + 5
"+"(5, 5)
```

### Vectorization

A collection of multiple values, usually related to one another somehow, is
called a _vector_. For example, (3, 2, 4) is a vector.

```r
c(1, 2, 3)
```

R is designed to make it easy to work with vectors. In fact, most of the
functions in R are _vectorized_. This means they work element-by-element.

In other words, if you call a vectorized function on a vector, the function
is called on every element of the vector, and you get a vector back.

    | 3 |                | sin(3) |
    | 2 |  -- sin() -->  | sin(2) |
    | 4 |                | sin(4) |

Operations like addition and multiplication are also vectorized.

```r
sin(c(3, 2, 4))
sum(c(3, 2, 4))
c(3, 2, 4) + c(9, 4, 7)
```

### Data Types

Data comes in all shapes and sizes. A _tabular_ data set is one with rows
and columns. Tabular data sets so common that there are specific terms to
describe them.

A _variable_ is something that the data set measures. For example, a data
set about people might have a "height" variable and a "eye color" variable.
Sometimes variables are called _covariates_ or _features_. These are just
different names for the same idea.

BE CAREFUL: "variable" in a data set and "variable" in a computer program
refer to two different concepts!

An _observation_ is a single set of measurements. Continuing the previous
example, an observation would correspond to the measurements recorded for
one person.

Traditionally, each row in a tabular data set is one observation and each
column is one variable.

Name   | Height | Eye Color | Education
------ | -----: | --------- | ---------
Gordon |  5'11" | Green     | PhD
Zoë    |   5'5" | Brown     | Some College
Simon  |   7'3" | Grey      | High School
Garret |   6'1" | Brown     | Grade 8
April  |   5'7" | Blue      | Some College

A _qualitative_ variable is one that measures something that falls into
specific categories. Qualitative variables can be either:

* _Categorical_, meaning there's no natural order for the categories. In the
 example, eye color is categorical.

* _Ordinal_, meaning there is a natural order for the categories. In the
 example, education is ordinal.

A _quantitative_ or _numerical_ variable is one that measures a number.


### Subsets

R represents tabular data as _data frames_. There are 2 ways to extract a
column from a data frame:

1. The `$` operator. Usage: `data$column_name`.

2. The `[[` operator. Usage: `data[["column_name"]]`.

The `$` operator is more convenient, because you don't have to put quotes
around the column name unless it contains a space or other special
character.

```r
dogs = readRDS("data/dogs.rds")
dogs

dogs$age
dogs$"breed"
dogs$bre

dogs[["breed"]]
dogs[[1]]
```

There are also 2 ways to extract rows from a data frame:

1. The `subset()` function. Usage: `subset(data, rows, columns)`.

2. The `[` operator. Usage: `data[rows, columns]`.

Note that both of these can also be used to extract columns.

```r
subset(dogs, TRUE)
subset(dogs, FALSE)
subset(dogs, age > 10)
dogs$age > 10

subset(dogs, age > 10, c("age", "breed"))

dogs[dogs$age > 10, c("age", "breed")]
dogs
dogs[dogs$age > 10, -3]

dogs[ , c(1, 2)]

dogs[1] # operates on columns

class(dogs[1])
class(dogs[[1]])
# [ take subsets, [[ extracts
```

It's common to specify which rows to keep using a condition. Use comparisons
and logical operators to write conditions.

Operator | Meaning
-------- | -------
==       | equal
!=       | not equal
<        | less than
<=       | less than or equal
>        | greater than
>=       | greater than or equal

&        | and
|        | or
!        | not
any()    | TRUE for any?
all()    | TRUE for all?

`condition1 & condition2` is TRUE if both sides are TRUE.


```r
subset(dogs, age < 10 & breed == "Chihuahua")
subset(dogs, age < 10 | breed == "Chihuahua")
subset(dogs, breed != "Chihuahua")

dogs$is_tiny_dog = dogs$breed == "Chihuahua"
subset(dogs, !is_tiny_dog)
```

`condition1 | condition2` is TRUE if either (or both) side is TRUE.

`!condition1` is TRUE if the condition isn't TRUE.

```r
any(dogs$breed == "Chihuahua")
any(dogs$breed == "Golden Retriever")
all(dogs$breed == "Chihuahua")

tiny_dogs = subset(dogs, is_tiny_dog)
all(tiny_dogs$breed == "Chihuahua")

table(dogs$breed)
```

### Summary Statistics

Summary statistics give an at-a-glance idea of how the values of a variable
are distributed. The most important characteristics are:

1. _Location_, which describes where most of the data is.

2. _Scale_, which describes how spread out the data is.

For qualitative data, the best way to examine the distribution is to
tabulate the frequency of each category.

For numerical data, frequencies usually aren't informative, because most
numbers only appear once. One way to handle this is to create artificial
categories that include a range of numbers. This is called _binning_ the
data.

The benefit of binning is that it makes numerical data simpler, but the
drawback is that it throws away potentially useful information. It's often
better examine numerical data using one of the summary statistics described
below.


Several different statistics can be used to summarize location:

1. The _mode_ is the most frequent value. This works well for qualitative
   data but poorly for numerical data.

2. The _median_ is the value in the middle of the sorted data.

3. The _mean_ is the balancing point of the data. Imagine the data is laid
   out by value on a serving platter, and a waiter is trying to balance the
   tray on one finger. This can only be calculated for numerical data.

```r
x = c(3, 4, 7)
mean(x)
median(x)

mean(c(x, 100))

median(c(x, 100))
```

Adding an extreme value to the data affects the mean more than the median.
Because of this, we say that the median is a _robust_ statistic.

Robust statistics give a more accurate summary if the extreme values were
recorded incorrectly. However, it can be very hard to judge whether or not
an extreme value is correct.

You can compare the mean and median to get an idea of how symmetrical a
distribution is.


The median is the 50th _percentile_ of the data, because 50% of the data is
smaller and 50% is larger.

Percentiles can be used to summarize the distribution of the data. For the
75th percentile, 75% of the data is smaller and 25% is larger. _Quantile_ is
another word for percentile.

The 0th, 25th, 50th, 75th, and 100th percentiles of a data set are called
_quartiles_, because they divide the data into 4 pieces.


There are also several ways to summarize scale:

1. The _standard deviation_ is based on the distance of every point from the
   mean. As a rule of thumb, most data will be within 3 standard deviations
   of the mean.

2. The _interquartile range_ is the difference between the 75th percentile
   and the 25th percentile.

Both of these only apply to numerical data, and larger values mean the data
is more spread out.

```r
x
quantile(x)
IQR(x)
```

### Plots

It's important to choose the right plot for the job.

A _bar plot_ shows the size of a measurement using a horizontal or vertical
bar. A _dot plot_ is similar, but uses a dot instead of a bar.

A _mosaic plot_ uses area to represent cross-tabulated categories. Each pair
of categories is shown as a box. The frequency of the pair determines the
size of its box.

Bar, dot, and mosaic plots can be used to show the distribution of
qualitative data.

```r
dogs
mosaicplot(breed ~ sex, dogs)

tab = table(dogs$breed, dogs$sex)
barplot(tab)
barplot(tab, beside = T)
```

A _box plot_ or _box and whisker plot_ shows the 25, 50, and 75 percentiles
of numerical data as a box with whiskers. Each whisker extends to the
farthest data point within 1.5 IQR of the box edge. Data points beyond
1.5 IQR from the box are called _outliers_ and get plotted individually.

              +-------------+
       |------|     |       |------------|          o
              +-------------+
    whisker  25%   50%     75%        whisker    outlier


A _histogram_ is a bar plot for binned numerical data. Each bar is the width
of its bin, so the bars are shown with no gaps between them.

A _density plot_ is a smoothed out histogram.

Box plots, histograms, and density plots are great for showing the
distribution of numerical data.

```r
hist(dogs$speed)
plot(density(dogs$speed))
```

_Scatter plots_ and _line plots_ are useful for showing the relationship
between two numerical variables. For instance, it's very common to make line
plots of some measurement against time.


What plot is appropriate?

Variable    | Versus      | Plot
----------- | ----------- | ----
numerical   |             | box, histogram, density
qualitative |             | bar, dot
qualitative | qualitative | mosaic, bar, dot
numerical   | qualitative | box,  density
numerical   | numerical   | scatter, smooth scatter, line

If you want to add a...

* 3rd numerical variable, use it to change point/line sizes.

* 3rd qualitative variable, use it to change point/line styles.

* 4th qualitative variable, use side-by-side plots.



### Formatting Plots

* Always add a title and axis labels. These should be in plain English, not
  variable names!

* Specify units after the axis label if the axis has units. For instance,
  "Height (ft)".

* Don't forget that many people are colorblind! Also, plots are often
  printed in black and white. Use point (`pch`) and line (`lty`) styles to
  distinguish groups; color is optional.

* Add a legend whenever you've used more than one point or line style.

* Always write a few sentences explaining what the plot reveals. Don't
  describe the plot, because the reader can just look at it. Instead,
  explain what they can learn from the plot and point out important details
  that are easily overlooked.

* Sometimes points get plotted on top of each other. This is called
  _overplotting_. Plots with a lot of overplotting can be hard to read and
  can even misrepresent the data by hiding how many points are present. The
  best way to deal with overplotting is to use a smooth scatter plot.
  Another strategy is to _jitter_ the points (move them a tiny amount) so
  they don't overlap completely.

* For side-by-side plots, use the same axis scales for both plots so that
  comparing them is not deceptive.


### Variable Scope

The _scope_ of a variable is the part of a program where the variable
exists.

A _local_ variable is a variable defined inside of a function. This includes
the function's parameters.

All other variables are called _global_ variables.

Local variables can only be used in the function where they were defined.

Global variables can be used anywhere, but local variables are given
priority. It's not possible to change a global variable from within a
function.


### Apply Functions

Apply functions apply a function to each element of a vector or list.

This is a lot like vectorization. Vectorization is faster, but apply
functions are more flexible.

Use vectorization rather than apply functions whenever possible!

