# STS 98 - Lecture 2016.03.31

Also see the [R output](r_session.txt). These notes are just a rough outline of
what we discussed in class; some topics may be missing.

## Type - What is it?

Every object in R has a _type_ that answers the question, "What is it?" For
instance, the type of the number `5.1` is `double`, which stands for
_double-precision_ and means it's a decimal number.

Types are useful for figuring out what kind of data is in a data set. Some
functions only work with specific types. For example, it doesn't make sense to
multiply the value `"hello"` by something. Understanding types can help you
detect bugs in your R code.

You can print the type of an object with the `typeof()` function:
```r
# Numbers
typeof(TRUE)
typeof(5.0)
typeof(3+1i)

# Text
typeof("I CAN HAZ DATA?")

# Function
typeof(cos)
```
Text values have the type `character`. Programmers usually call text values
_strings_, because they're a string (or sequence) of characters.

In R, the elements of a vector must all have the same type, and the type of a
vector is the same as the type of its elements. So the values `2.1` and `c(2.1,
2.4, 3.6)` both have type `double`.

You might want to store a bunch of values with different types in a single
variable. You can do this with a list. A _list_ holds multiple elements, like a
vector, but each element can have any type. To create a list, use the `list`
function:
```r
x = list("GR", 8, 4, "U")
```
The type of a list is `list`. You can create complicated data structures by
putting lists inside of each other.


## Class - What does it do?

Every value in R has one or more _classes_, which answer the question "What
does it do?" The number `5.1` has class `numeric`, which means that `5.1` acts
like a number.

Like types, classes are useful for figuring out what kind of data is in a data
set, as well as for catching bugs.

You can check the class of an object with the `class()` function:
```r
# Numbers
class(TRUE)
class(5.0)
class(3+1i)

# Text
class("MOAR DATA PLZ")

# Function
class(cos)
```
Often an object's type and class are the same. Later on, we'll see some objects
where the type and class are different.


## Getting Around

In the previous lecture, we saw how to get around on the command line by
changing the working directory. R also has a working directory, but the
commands are different.

To view the working directory (compare to `pwd`):
```r
getwd()
```

To list the files in the working directory (compare to `ls`):
```r
list.files()
```

To change the working directory to the folder `foo` (compare to `cd foo`):
```r
setwd("foo")
```

When you start working on a project, it's a good idea to change R's working
directory to the folder that contains your data.


## Loading Data

There are lots of different file formats for storing data.

Extensions help identify the format of a file. An _extension_ is a dot followed
by a few letters (usually 3) at the end of a file's name. For example, a file
named `foo.txt` has the extension ".txt", which means it's a plain text file.
Some common extensions for data are:

* `.rds`: R data (one data set)
* `.rda`: R data (one or more data sets)
* `.csv`: comma-separated values
* `.tsv`: tab-separated values

The R data formats are _binary_, which means the data is stored in a way that
only certain programs understand (in this case, R). If you open binary files in
a text editor, you'll see a bunch of nonsense, because your editor has no idea
how to make sense of the file.

On the other hand, the CSV and TSV formats are plain text. Columns are
separated by commas or tabs, and each row is put on a separate line. If you
open these files in your text editor, you'll see the data as if someone had
typed it in.

To load data into R, you need to choose the right function for the job! Check
the file format of the data to decide. A few of the R functions for loading
data are:

* `load()`: RDA files
* `readRDS()`: RDS files
* `read.csv()`: CSV files
* `read.delim()`: TSV files
* `read.table()`: other plain text tables

The CSV format is very popular for online data, because you don't need any
special programs to view it. We'll mainly use RDS and CSV in this class.


## Inspecting Data

Let's use R to get to know the class. Load the file `sts98.rds`:
```r
x = readRDS("sts98.rds")
```
This file has data on the year and major of every student enrolled in the
class.

When you load data you've never seen before, you should start by trying to
figure out how it's organized. To peek at the top of a data set, use the
function `head()`. For instance,
```r
head(x)
```
shows that the student data is a table with columns "Class", "Major", and
"Dept". You could've printed out the whole data set by typing its name (`x`),
but if there are a lot of rows, they'd go whizzing by as R prints them all.
It's easier and faster to peek using `head()`. If you'd rather see the bottom
of the data set instead, you can use `tail()`:
```r
tail(x)
```
Both functions accept a second argument that says how many rows to print out.
So
```r
head(x, 10)
```
would print the first 10 rows.

You can check the number of rows in a data set with the `nrow()` function:
```r
nrow(x)
```
Similarly, you can check the number of columns with `ncol()`. You can even
check both at the same time with the `dim()` function (short for "dimensions"):
```r
dim(x)
```
Only tabular data has dimensions. If you call `dim()` on a vector,
```r
dim(3:4)
```
you get `NULL`, which means there's no value. Still, vectors do have length,
and there's a function to check their length:
```r
length(3:4)
```
So there are several different ways to check the "size" of an object in R.

The columns of a data frame can have names. You can get the names with the
`colnames()` function:
```r
colnames(x)
```
Similarly, there's a `rownames()` function to get row names. Finally, there's a
`names()` function, which gets the name on each element of an object. If you
run
```
names(x)
```
you get back the column names. This is a hint that the "elements" of the data
frame are its columns.

The type of the STS 98 data set is `list`:
```r
typeof(x)
```
and the class is `data.frame`:
```r
class(x)
```
In R, a _data frame_ is just a table of data. Each row is one observation---in
this case, one student. Each column is a variable---something measured about
the students. Each column has its own type, and the column types might be
different, so under-the-hood R uses a list to store the data frame. The columns
are the elements of the list. This is also why `names()` gives us the column
names.

You can learn more about the columns of a data frame with the `str()` function
(this stands for "structure").
```
str(x)
```
This tells us there are 3 columns, all of which are "Factors". A _factor_ is
just data that falls into specific categories. For instance, a student's class
can be "Freshman", "Sophomore", and so on. This is different from a numerical
measurement, say height, where there aren't specific categories, just a range
of values.

# Analyzing the Student Data

We can use R to get some idea of what kinds of students are in the class. We
could just print out the whole data frame and try to eyeball it, but that's
missing the whole point of R! We can grab just the column with information
about people's year:
```r
x$Class
```
The `$` tells R that we want to get a specific column by name. This is still
pretty messy to look at, though. Let's have R count the number of students in
each class level:
```r
table(x$Class)
```
The `table()` function computes a table of counts. In this case, we can see
that most of the class is seniors and juniors.

We can do the same thing to get an idea of the majors:
```r
table(x$Major)
```
It's a little hard to see which major has the most students. We can fix that by
sorting the table:
```r
sort(table(x$Major))
```
Now it's easy to see that most of the class is in Economics, with English the
next most common major.

This kind of analysis is pretty common, so there's a shortcut. We can use the
`summary()` function to quickly get a summary of every column:
```r
summary(x)
```

We can also use `table()` to cross-tabulate student class level and major:
```r
table(x$Class, x$Major)
```
This shows a breakdown of class level by major.
