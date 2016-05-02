x = readRDS('~/projects/sts98/assignment-3/hcmst.rds')

dogs = readRDS("~/projects/sts98/sts98notes/data/dogs.rds")

# Questions

# Diff between variable in dataset and in program

# make up example questions, conclusions

f = function(x){
  newone = 10
  x^2 + newone
}

table(x$breakup)

# 
bage = tapply(x$age, x$breakup, FUN=mean, na.rm=TRUE)

# Forget NA's for the moment
breakup = x$breakup
breakup[is.na(breakup)] = 'yes'

age = x$age

# What this actually does:
b1 = breakup == 'yes'
b2 = breakup == 'partner deceased'
b3 = breakup == 'no'

length(age[b1])
length(age[b2])
length(age[b3])

mean(age[b3], na.rm=TRUE)

s = x[, c('age', 'partner_age')]
s = s[complete.cases(s), ]

a = as.matrix(s)
p = prop.table(a, margin=1)

colMeans(s)
apply(s, 2, mean)



# 11AM Discussion

f = function(x){
  #something = 10
  x^2 + something
}

z = 1:3
sapply(z, f)

class(dogs[, 1])
class(dogs[, 2])

sapply(dogs, class)

# Data types
# Promotion
a = c(TRUE, FALSE)
a2 = c(a, 1:2)
a3 = c(a2, 3.1425)

x = list(a=1:4, b=c(1, 8.2))

sapply(x, length)

sapply(length, x)

adder = function(x){
  function(y) y + x
}

a2 = adder(2)

x = rnorm(100)







