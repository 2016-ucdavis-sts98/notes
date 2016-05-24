par(no.readonly = T)
setwd("~/Documents/STS_98_assignments")

#load the databases from https://www.yelp.com/healthscores/feeds (I am using LA county data)
business=read.csv("LABusinesses/businesses.csv")
inspections=read.csv("LABusinesses/inspections.csv")
feed_info=read.csv("LABusinesses/feed_info.csv")
legend=read.csv("LABusinesses/legend.csv")
violations=read.csv("LABusinesses/violations.csv")

#get a feel for the data:
names(business)
names(inspections)
names(violations)
summary(business)
summary(inspections)
summary(violations)
legend
feed_info

#merge the variables together 
bus_ins=merge(business,inspections, by= "business_id")
bus_ins_vio=merge(bus_ins,violations, by= c("business_id","date"))
names(bus_ins_vio)
#what is wrong here?  What is description.x and description.y?
head(violations$description)
head(inspections$description)
head(bus_ins$description)
table(is.na(bus_ins$description))
#looks like this description.x all NAs.  We could look at the documentation on yelp to figure out why this is here?  But no harm in removing it for now
bus_ins$description =NULL
names(bus_ins)
#if we wanted to, we could also change the name of the column by using colnames(), such as:
# colnames(bus_ins)[12]="newName"
#This would have been the better option if the column was not blank.

#Let's remake bus_ins_vio
bus_ins_vio=merge(bus_ins,violations, by= c("business_id","date"))


#any other weird things about the data?  It is worthwhile to do a summary or a table for each statistic.  Check out:

table(bus_ins_vio$state)

#This could cause a problem if the state is capitalized differently in violations (if violations has a state variable, which it does not).  So, let's make everything "CA"
levels(bus_ins$state)
levels(bus_ins$state)=c("CA","CA")


#Note it there are probably better ways to do that in this particular case (actually replacing #the "ca"" with "CA", using an sapply function).  But changing levels is usually needed when
#you are merging tables that have been labled differently, so I'm showing an example of it 
#here. You should set the levels so that they match between dataframe, such as:
# levels(bus_ins$state)=c("what "ca" is in the other dataframe","CA")

#how can we get the index's of all of the plumbing related violations? Say we wanted to map these to see
#if they were all in the same part of the city.
grep("Plumbing",bus_ins_vio$description, fixed=TRUE)

#missing anything?  How about:

grep("plumbing",bus_ins_vio$description, fixed=TRUE)
  

#so, to get a vector of indexes,
foo=grep("Plumbing",bus_ins_vio$description, fixed=TRUE)
bar=grep("plumbing",bus_ins_vio$description, fixed=TRUE)
plumbing_related_violations=c(foo,bar)
