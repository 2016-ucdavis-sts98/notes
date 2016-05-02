name
#First, load the data set if you have not yet. (readRDS())

#Let's say, for the homework,  you need to look at the age of everyone in the study.  
#What type of graph/figure should we use for this?

total_age=c(HCM$age,HCM$partner_age)


#Let's make a histogram.  Make the simpalist histogram you can. Do this with your partner!
barplot(c(HCM$age,HCM$partner_age))

#Let's change the bottom access to be more readable on the first plot
hist(c(HCM$age,HCM$partner_age), xaxt= 'n')
x_coords=c(16,22,30,40,60,100)
axis(1, x_coords, TRUE)


#Now, let's bin these into groups. For this, we use the cut() function. 
#what groups make sense for us to cut them into?

total_age= c(HCM$age,HCM$partner_age)
breakpoints= c(16,22,30,40,60)
label=c("pre college", "twenties","thirties","forties and fifties")
foo=cut(total_age,breakpoints, labels =label)
head(foo)
plot(foo)


