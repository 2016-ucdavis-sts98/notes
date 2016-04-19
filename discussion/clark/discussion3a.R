setwd('/Users/clark/projects/sts98/sts98notes')
# %in%

x = readRDS('/Users/clark/projects/sts98/assignment-2-clarkfitzg/usda_prices.rds')

# Question 7

# Plotting model
# Lines
x = seq(1, 10, length.out = 100)
sinx = sin(x)
y = 0.15 * x - 2

plot(x, sinx, ylim=c(-2, 2), type='l'
     , main='favorite math functions'
     , ylab='y'
     #, xaxt='n'
     )

lines(x, y, lty=2)
legend('topright', legend=c('sin', 'line'), lty=c(1, 2))

#legend(4.4, 0.5, legend=c('sin', 'line'), lty=c(1, 2))








# Random stuff
set.seed(37)
normal = rnorm(10000)
uniform = runif(5000) + 5
both = c(normal, uniform)

boxplot(normal)

hist(both, breaks=80)

plot(density(both))

random[1:5000] = runif(5000)

hist(random)

plot(density(rnorm(10000)))

# Meaning of boxplot
# Range x, y
# manipulating labels











