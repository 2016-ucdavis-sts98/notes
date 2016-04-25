# Questions




# Mosaic plot?
# 3 - do subjects have anything in common?

# DRY - do not repeat yourself

# Code that sometimes works versus code that works

# Combining & with | is difficult to understand
# and should be avoided

FALSE & FALSE | TRUE & TRUE

(FALSE & FALSE) | (TRUE & TRUE)

FALSE & (FALSE | TRUE) & TRUE

# Bunch of &'s and |'s are easy!
# For &, it's TRUE iff they are all TRUE
TRUE & TRUE & TRUE & FALSE
# For |, it's TRUE iff There is at least one TRUE
FALSE | FALSE | TRUE | FALSE

x = rnorm(100, sd=10)
sd(x)
var(x)

ice = subset(x, food == "ice cream and frozen desserts" & year >= 2005)

west = subset(ice, region == "West" & division != "Mountain")
east = subset(ice, region == "Northeast" | division == "South Atlantic")
