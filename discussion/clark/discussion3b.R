# General plotting model
# It's a canvas
x = seq(0, 10, length.out = 100)
y1 = sin(x)
y2 = 0.2 * x -2

plot(x, y1, ylim=c(-2, 3)
     , type='l'
     , main='my favorite math functions'
     )
lines(x, y2, lty=2)
legend('topright', legend=c('sin', 'line'), lty=c(1, 2))


points(x, y2, pch=2)

# Box plots
# Analyzing variance in boxplots
# Subsetting, and plotting from
x = readRDS('/Users/clark/projects/sts98/assignment-2-clarkfitzg/usda_prices.rds')

#dairy = x$food %in% c('regular fat milk', 'low fat milk', 'low fat cheese')

milk = x[x$food == 'regular fat milk', ]

boxplot(price ~ date, milk)

# Random numbers
normal = rnorm(10000)
uniform = runif(5000)
uniform = uniform + 3

hist(normal, 80)
plot(density(normal))
hist(uniform)

both = c(normal, uniform)
hist(both)
plot(density(both))

boxplot(normal)










