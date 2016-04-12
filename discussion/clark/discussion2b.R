# Assignment 2 in general

# Subsets

x = 1:10

# x which are less than 3
# x[selection]

less3 = x < 3

x[less3]
x[x < 3]

# x less than 3 or greater than 8
x[x < 3 | x > 8]

cond = x < 3 | x > 8

sum(x[cond])
sum(cond)
sum(x < 3 | x > 8)

x[2] = NA
# is x NA?
is.na(x)

# Sum x without nas
xna = is.na(x)
# Christie
goodx = x[!is.na(x)]

# Boolean logic
TRUE & TRUE

TRUE & FALSE

# Naveed
TRUE | FALSE

# Connie
FALSE | FALSE

# David
# TRUE is 1, FALSE is 0

# Jacob
is.na(x)
x == NA

sum(c(Inf, 0, 1, 2))

sum(c(NA, 0, 1, 2))

p1 = prices$year
p2 = prices[, 'year']

same = p1 == p2

# Desiree
all(p1 == p2)

# prices from year 2004
p04 = prices[p1 == 2004, ]

p04 = prices[prices$year == 2004, ]

colnames(prices)

foodandprice = prices[, c('food', 'price')]

p04_fp = prices[prices$year == 2004, c('food', 'price')]

plast = p04[, c('food', 'price')]


