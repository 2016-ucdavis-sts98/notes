setwd("~/projects/sts98/assignment-2-clarkfitzg")

prices = readRDS('usda_prices.rds')

sapply(prices, class)

# price over time

# Questions
# Subsetting
# Pick out the minimum value
# hw 2 - pick out the NA's

# Basics of graphs

x = 1:10

# elements of x larger than 8
greater8 = x > 8

x[x > 8]
subset(x, x > 8)

x[greater8]

# elements of x larger than 8 or less than 3
less3 = x < 3

x[x < 3 | x > 8]

# Boolean logic
TRUE & TRUE
TRUE & FALSE
TRUE | FALSE
FALSE | FALSE
TRUE | TRUE

sum(x < 3)
sum(x[x < 3])

x[3] = NA
y = 1:10
y[3] = Inf

# Two ways to get rid of the NA
# Take it out
x[-3]
x[!is.na(x)]

sum(less3, )

table(as.factor(c('a', 'a', 'b')))

# Subsets of data frames
yr = prices$year
yr2 = prices[, 'year']

yr2004 = prices$year == 2004

dim(prices)

# prices[row selection, column selection]
p = prices[yr2004, ]
p = prices[prices$year == 2004, ]

length(yr2004)
sum(yr2004)
dim(p)
