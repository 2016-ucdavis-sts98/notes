setwd("~/projects/sts98/assignment-2-clarkfitzg")

prices = readRDS('usda_prices.rds')

# Example of a legend
x = 1:10
r1 = rnorm(10)
r2 = rnorm(10)

plot(x, r1, type='l', ylim=c(-3, 5))
lines(x, r2, lty=2)

legend(1.78, 2.89, legend=c('r1', 'r2'), lty=c(1, 2))

#legend('topright' legend=c('r1', 'r2'), lty=c(1, 2))

legend(-166.7, -36.5, legend = "Earthquake", pch = 1, col = "plum")

boxplot(price ~ date, data=prices)

length(unique(prices$food))

# Select the data where the food is 'oils'
oil = prices[prices$food == 'oils', ]

yr2004 = prices[prices$year == 2004, ]

yr4 = prices[prices$year < 2007, ]

pdf('boxplots.pdf')
boxplot(price ~ date, data=prices)
dev.off()

# year is not 2004
yrnot04 = prices$year != 2004

# food is ice cream and frozen dessert
icecream = prices$food == 'ice cream and frozen desserts'

# northeast coast
northeast = prices$division %in% c('New England', 'Middle Atlantic')

a = yrnot04 & icecream & northeast

aprices = prices[a, ]



