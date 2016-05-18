apt = read.csv('cl_apartments.csv')

# price = b0 + b1*bedrooms + b2*bathrooms + b3*bedrooms*bathrooms
model = lm(price ~ bedrooms + bathrooms + shp_county, apt)


summary(model)

plot(apt$bedrooms, apt$price, ylim=c(0, 8000))

abline(model)

pdf('pricebedroom.pdf')
boxplot(price ~ bedrooms, data=apt)
dev.off()

boxplot(apt$price ~ apt$bedrooms)

library(RCurl)

# Getting the density

# After downloading to my local 
dens = readHTMLTable('List_of_cities_and_towns_in_California')

sapply(dens, class)
lapply(dens, dim)

d2 = dens[[2]][-1, c(1, 3, 4, 5, 6)]
head(d2)
