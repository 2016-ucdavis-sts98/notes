#Git

#You have been told that you need to add a file to a repository for your homework. 
#Describe how you would do this

#Vector manipulation
#1) What does this return?

Bob=c(2,5,3)
Bob[c(TRUE,FALSE,FALSE)]
Bob[Bob==2]
Bob==2
#2
Bob[c(3,1,2)]

#3
Ralph=c(3,2,1)
Bob*Ralph
Bob+Bob
c(Bob,Ralph)

#functions and scope:
#What does this return
x=3
y=2

foo=function(x,y){
  x
}
foo(y,x)

#2)#What does this do?
x=3
y=2

bar=function(x){
  return=x
  y
}

bar(12)

#Data table manipulation
dogs=readRDS("dogs.rds")

#    age speed     breed sex
#1   NA   9.0 Chihuahua   F
#2   10  12.7  Labrador   M
#3   13   6.6    Poodle   M
#4   11  12.3  Labrador   M
#5    8  14.2 Chihuahua   M
#6    7  10.4  Labrador   M
#7    8   8.3    Poodle   M
#8   11  13.3 Chihuahua   M
#9    9  11.5  Labrador   M
#10  12  12.2 Chihuahua   F


#Describe what is happening here 
tab = table(dogs$breed)
names(tab) = c("Tiny Dog", "Happy Dog", "Fluffy Dog")
tab
table(dogs$breed)
# What does this return?
subset(dogs, age < 10 & breed == "Chihuahua")

#Draw a boxplot.  Mark the First, second, and third quartile.  What do the whiskers mean?



#What does this return?
by_sex = split(dogs$speed, dogs$sex)
sapply(by_sex, mean)

#What does this return?
standardized_speed = function(x) {
  mean(x$speed / x$age, na.rm = T) 
}
spl = split(dogs, dogs$breed)
standardized_speed(spl$Poodle)
lapply(spl, standardized_speed)
