# How to program

# The task: make a bar plot of age distributions
source('plotfunctions.R')

x = readRDS('~/projects/sts98/assignment-3/hcmst.rds')

#par(mfrow=c(1,1))
plotages(x$age, xlab='Age Group', ylab='Counts')

#plotages(x$partner_age, main='Partner Age')









