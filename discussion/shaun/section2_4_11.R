# 0) Clone the repository (git clone https://github.com/everett-wetchler/okcupid)
# 1)Load profiles.20120630.csv that includes more than the age, name, and gender (you might need read.csv()!)
profiles= read.csv("./okcupid/profiles.20120630.csv")

#2)How big is this dataset? What variables does it contain?
dim(profiles)
names(profiles)

#3)Find the max, min, mean, and median of age in this dataset

summary(profiles$age)
# Could also do min(profiles$age), etc.

#4)What is the distribution of reported sexes?
table(profiles$sex)
# Make a figure describing sex in the dataset. Make it look pretty!
dotchart(table(profiles$sex),main="Sexes in Okcupid data", 
         xlab="number", ylab="ages",xlim=c(0,50000))

#5) What about sexual orientation? Make a figure for this, also.  
table(profiles$orientation)
dotchart(table(profiles$orientation),main="Sexual orientation",
         xlab="frequency", ylab="Orientation",mgp=c(3.7,0,1))
#6)Do males and females tend to report as gay or bisexual at different rates? 
# Make two tables of them.  

males=subset(profiles,sex=="m")
females=subset(profiles,sex=="f")


dotchart(table(females$orientation),main="Sexual orientation of women",
         xlab="frequency" , ylab="Orientation", mgp=c(3.7,0,1))
dotchart(table(males$orientation), main="Sexual orientation of men",
         xlab="frequency" , ylab="Orientation", mgp=c(3.7,0,1))

#7)What other interesting plots/data can you pull from this dataset?  
# You will have to be more creative for projects 3 and beyond, so look around the data and 
# see if you can find anything interesting!
