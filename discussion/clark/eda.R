hcmst = readRDS('hcmst.rds')

a = hcmst[!is.na(hcmst$breakup), ]
a$breakupTRUE = a$breakup == 'yes'

fit = glm(breakupTRUE ~ met_online
          , data=a, family='binomial')
summary(fit)

hist(hcmst$relationship_quality)

r = hcmst$relationship_quality

plot(r)

r2 = as.integer(r)
hist(r2)

hcmst$positive = hcmst$relationship_quality %in% c('good', 'excellent')
hcmst$positive[is.na(hcmst$relationship_quality)] = NA
summary(hcmst$positive)

'a' %in% letters
'A' %in% letters


x = hcmst
h = subset(x, !x$partner_same_sex)

# difference in age
h$agediff = h$age - h$partner_age
females = h$gender == 'female'

# Define as the males age - females age
h$m_f_age = h$agediff
h$m_f_age[females] = -h$agediff[females]

# Define as the males age - females age
h = h[!is.na(h$m_f_age), ]

# What's the proportion of relationships where the male is
# at least as old as the female?
sum(h$m_f_age >= 0) / length(h$m_f_age)

min(h$m_f_age)
max(h$m_f_age)

# Define as the males age - females age
#h$m_f_age = ifelse(females, -h$agediff, h$agediff)

hist(h$agediff)



heterosexualcouplemale = subset(heterosexualcouple, gender == "male")
heterosexualcouplefemale = subset(heterosexualcouple, gender == "female")









