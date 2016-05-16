apt = read.csv('cl_apartments.csv')

sapply(apt, class)

apt$bath2 = ceiling(apt$bathrooms)
model = lm(price ~ bedrooms*bath2, data=apt)
summary(model)

coef(model)

# Convert from factor into dates
d = as.Date(apt$date_posted)
d[2] - d[1]