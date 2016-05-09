# How to program
# http://norvig.com/21-days.html

x = readRDS('~/projects/sts98/assignment-3/hcmst.rds')

source('plotfunctions.R')

ageplot(x$age, main='Age for participant', xlab='Age group', ylab='Count')

pdf('example.pdf')
ageplot(x$partner_age)
dev.off()