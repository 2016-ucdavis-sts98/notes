# Some helper functions for plotting


ageplot = function(age, main='Ages', ...){
  # Make bar chart of age by bins
  #
  # Parameters
  # age -   numeric vector of age in years
  #
  brks = c(0, 18, 25, 50, Inf)
  labs = c('minor', 'college', 'middle', 'senior')
  
  agebin = cut(age, breaks=brks, labels=labs)
  plot(agebin, main=main, ...)
}

plotages = function(age, main='Frequency of Age Groups', ...){
  # Make a bar plot of ages
  #
  # Parameters:
  # age:    vector of numeric ages in years
  #
  brk = c(0, 18, 25, 50, Inf)
  labs = c('minor', 'college', 'middle', 'senior')
  
  agebin = cut(age, breaks=brk, labels=labs)
  plot(agebin, main=main, ...)  
}