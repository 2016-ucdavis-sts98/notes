#Download and read hcmst.rds from Assignment 3 "hcmst.rds"

HCL= readRDS("./assignment-3-Airwhale/hcmst.rds")

#Get a feel for the size and shape of the data... how do you initially look at a new database?
dim(HCL)
colnames(HCL)
names(HCL)
summary(HCL)
str(HCL)
#You also could and probably should look it up in the codebook, to know things about how data was sampled, what 
#specific questions were asked, etc!

#what does binning mean?

#Any interesting things about the data-set?  Any problems with the way they structured their variables? 

#Lots of questions about types and changing types in class!  
#Here are a few pieces of code to remind you of what we talked about

#Turning HCL$gender_attraction into a logical:
HCL$is_same_sex_attraction= "only same gender"==HCL$gender_attraction

#turning HCL$survey_date into a date (I had this slightly wrong in section)
string_date= paste(substr(as.character(HCL$survey_date),1,4),"-",
                   substr(as.character(HCL$survey_date),5,6),"-","01", sep='')
as.Date(string_date, "%Y-%m-%d")


str#let's a simple graph!  Graph years of education and their partner's education 
#(Several ways you could interperate this question)
boxplot(c(HCL$years_edu,HCL$partner_years_edu),main="Years of education",
        ylab="Subject's years of education") 
#in your homework this sort of graph should have main and xlab, ylab defined

#Are there other ways we could read the question, or get other interesting things from the data?
scatter.smooth(HCL$years_edu ~HCL$partner_years_edu, type="n" ,main="Years of education", 
                ylab="Subject's years of education",
                xlab="Partner's years of education")

#What other questions could you ask for #10 in the homework?  What makes a good question?

#Questions that imply causality are always good!